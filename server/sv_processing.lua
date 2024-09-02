local QBCore = exports['qb-core']:GetCoreObject()

-- Handle Order Submission
RegisterNetEvent('restaurant:orderIngredients')
AddEventHandler('restaurant:orderIngredients', function(ingredient, quantity, restaurantId)
    local playerId = source

    -- Ensure quantity is a number and playerId is valid
    quantity = tonumber(quantity)
    if not quantity or quantity <= 0 then
        TriggerClientEvent('ox_lib:notify', playerId, {
            title = 'Order Error',
            description = 'The quantity provided is not valid. Please check and try again.',
            type = 'error',
            showDuration = true,
            duration = 10000
        })
        return
    end

    -- Fetch restaurant-specific items based on the restaurantId
    local restaurantJob = Config.Restaurants[restaurantId] and Config.Restaurants[restaurantId].job
    if not restaurantJob then
        TriggerClientEvent('ox_lib:notify', playerId, {
            title = 'Order Error',
            description = 'The restaurant ID is not valid. Please check and try again.',
            type = 'error',
            showDuration = true,
            duration = 10000
        })
        return
    end

    local restaurantItems = Config.Items[restaurantJob] or {}
    local item = restaurantItems[ingredient]

    if item then
        local totalCost = item.price * quantity

        -- Fetch the player object
        local xPlayer = QBCore.Functions.GetPlayer(playerId)
        if xPlayer then
            -- Check if player has enough money in their bank
            if xPlayer.PlayerData.money.bank >= totalCost then
                -- Deduct the amount from the player's bank account
                xPlayer.Functions.RemoveMoney('bank', totalCost, "Ordered ingredients for restaurant")

                MySQL.Async.execute('INSERT INTO orders (owner_id, ingredient, quantity, status, restaurant_id, total_cost) VALUES (@owner_id, @ingredient, @quantity, @status, @restaurant_id, @total_cost)', {
                    ['@owner_id'] = playerId,
                    ['@ingredient'] = item.name,
                    ['@quantity'] = quantity,
                    ['@status'] = 'pending',
                    ['@restaurant_id'] = restaurantId,
                    ['@total_cost'] = totalCost
                }, function(rowsChanged)
                    -- Notify the player about the order status
                    if rowsChanged > 0 then
                        TriggerClientEvent('ox_lib:notify', playerId, {
                            title = 'Order Submitted',
                            description = string.format('You have successfully ordered %d of %s. Total cost: $%d', quantity, item.name, totalCost),
                            type = 'success',
                            showDuration = true,
                            duration = 10000
                        })
                        -- Also trigger showing order details on the client side
                        TriggerClientEvent('restaurant:showOrderDetails', playerId, item.name, quantity, totalCost)
                    else
                        TriggerClientEvent('ox_lib:notify', playerId, {
                            title = 'Order Error',
                            description = 'An error occurred while processing your order. Please try again.',
                            type = 'error',
                            showDuration = true,
                            duration = 10000
                        })
                    end
                end)
            else
                TriggerClientEvent('ox_lib:notify', playerId, {
                    title = 'Insufficient Funds',
                    description = 'You do not have enough money in your bank account to complete this order.',
                    type = 'error',
                    showDuration = true,
                    duration = 10000
                })
            end
        else
            TriggerClientEvent('ox_lib:notify', playerId, {
                title = 'Order Error',
                description = 'An error occurred while processing your order. Please try again.',
                type = 'error',
                showDuration = true,
                duration = 10000
            })
        end
    else
        TriggerClientEvent('ox_lib:notify', playerId, {
            title = 'Order Error',
            description = 'The ingredient you provided is not found. Please check and try again.',
            type = 'error',
            showDuration = true,
            duration = 10000
        })
    end
end)

-- Server-side: Update stock and pay driver
RegisterNetEvent('update:stock')
AddEventHandler('update:stock', function(restaurantId)
    local src = source

    if not restaurantId then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Error',
            description = 'Invalid restaurant ID for stock update.',
            type = 'error',
            position = 'top-right',
            showDuration = true,
            duration = 10000
        })
        return
    end

    MySQL.Async.fetchAll('SELECT * FROM orders WHERE restaurant_id = @restaurant_id AND status IN ("pending", "accepted")', {
        ['@restaurant_id'] = restaurantId
    }, function(orders)
        local queries = {}
        local totalCost = 0

        for _, order in ipairs(orders) do
            local orderId = order.id
            local ingredient = order.ingredient:lower()
            local quantity = tonumber(order.quantity)
            local orderCost = order.total_cost or 0

            if ingredient and quantity then
                table.insert(queries, string.format(
                    'UPDATE orders SET status = "completed" WHERE id = %d',
                    orderId
                ))

                table.insert(queries, string.format(
                    'INSERT INTO stock (restaurant_id, ingredient, quantity) VALUES (%d, "%s", %d) ON DUPLICATE KEY UPDATE quantity = quantity + %d',
                    restaurantId,
                    ingredient,
                    quantity,
                    quantity
                ))

                totalCost = totalCost + orderCost

            else
                print("Error: Invalid order data. Ingredient or quantity is nil.")
            end
        end

        -- Execute transaction
        MySQL.Async.transaction(queries, function(success)
            if success then
                TriggerClientEvent('ox_lib:notify', src, {
                    title = 'Stock Updated',
                    description = 'Orders marked as complete and stock updated successfully!',
                    type = 'success',
                    position = 'top-right',
                    showDuration = true,
                    duration = 10000
                })

                -- Calculate driver payment based on total cost
                local driverPayment = totalCost * Config.DriverPayPrec
                TriggerEvent('pay:driver', src, driverPayment)
            else
                TriggerClientEvent('ox_lib:notify', src, {
                    title = 'Error',
                    description = 'Failed to update stock or mark orders as complete.',
                    type = 'error',
                    position = 'top-right',
                    showDuration = true,
                    duration = 10000
                })
            end
        end)
    end)
end)

RegisterNetEvent('pay:driver')
AddEventHandler('pay:driver', function(driverId, amount)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(driverId)

    if xPlayer then
        xPlayer.Functions.AddMoney('bank', amount, "Payment for delivery")

        TriggerClientEvent('ox_lib:notify', driverId, {
            title = 'Payment Received',
            description = 'You have been paid $' .. amount .. ' for the delivery.',
            type = 'success',
            position = 'top-right',
            showDuration = true,
            duration = 10000
        })
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Error',
            description = 'Unable to find the player to process payment.',
            type = 'error',
            position = 'top-right',
            showDuration = true,
            duration = 10000
        })
    end
end)

RegisterNetEvent('warehouse:getPendingOrders')
AddEventHandler('warehouse:getPendingOrders', function()
    local playerId = source

    MySQL.Async.fetchAll('SELECT * FROM orders WHERE status = @status', {
        ['@status'] = 'pending',
    }, function(results)
        if not results then
            print("Error: No results returned from database.")
            return
        end

        local orders = {}

        for _, order in ipairs(results) do
            -- Get the restaurant job from Config.Restaurants
            local restaurantData = Config.Restaurants[order.restaurant_id]
            local restaurantJob = restaurantData and restaurantData.job

            -- Print the item list for the current restaurant job
            if Config.Items[restaurantJob] then

            else
                print("Error: Config.Items[", restaurantJob, "] does not exist.")
            end

            -- Get item details from Config.Items based on the restaurant's job
            local itemKey = order.ingredient:lower()
            local item = Config.Items[restaurantJob] and Config.Items[restaurantJob][itemKey]

            if item then
                table.insert(orders, {
                    id = order.id,
                    ownerId = order.owner_id,
                    itemName = item.name,
                    quantity = order.quantity,
                    totalCost = item.price * order.quantity,
                    restaurantId = order.restaurant_id
                })
            else
                print("Error: Item not found for ingredient:", order.ingredient, "Restaurant job:", restaurantJob)
            end
        end

        TriggerClientEvent('warehouse:showOrderDetails', playerId, orders)
    end)
end)

-- Fetch and show stock details
RegisterNetEvent('restaurant:requestStock')
AddEventHandler('restaurant:requestStock', function(restaurantId)
    local playerId = source
    MySQL.Async.fetchAll('SELECT * FROM stock WHERE restaurant_id = @restaurant_id', {
        ['@restaurant_id'] = restaurantId
    }, function(results)
        local stock = {}
        local itemsToDelete = {}

        -- Collect items to delete and build the stock table
        for _, item in ipairs(results) do
            if item.quantity <= 0 then
                table.insert(itemsToDelete, item.id)  -- Collect item IDs to delete
            else
                stock[item.ingredient] = item.quantity
            end
        end

        -- Delete items with quantity <= 0
        for _, itemId in ipairs(itemsToDelete) do
            MySQL.Async.execute('DELETE FROM stock WHERE id = @id', {
                ['@id'] = itemId
            })
        end

        -- Pass the cleaned stock table to the client
        TriggerClientEvent('restaurant:showResturantStock', playerId, stock, restaurantId)
    end)
end)

RegisterNetEvent('warehouse:getStocks')
AddEventHandler('warehouse:getStocks', function()
    local playerId = source
    MySQL.Async.fetchAll('SELECT * FROM warehouse_stock', {}, function(results)
        local stock = {}

        for _, item in ipairs(results) do
            stock[item.ingredient] = item.quantity
        end
        TriggerClientEvent('restaurant:showStockDetails', playerId, stock, restaurantId)
    end)
end)


RegisterNetEvent('restaurant:withdrawStock')
AddEventHandler('restaurant:withdrawStock', function(restaurantId, ingredient, amount)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    
    if player then
        for job, items in pairs(Config.Items) do
            for item, data in pairs(items) do
                print("Job: " .. job .. ", Item: " .. item .. ", Item Name: " .. data.name)
            end
        end

        ingredient = trim(ingredient)

        local restaurantJob = Config.Restaurants[restaurantId].job

        local itemData = Config.Items[restaurantJob] and Config.Items[restaurantJob][ingredient]
        
        if itemData then
            local amountNum = tonumber(amount)
            if amountNum and amountNum > 0 then
                player.Functions.AddItem(itemData.name, amountNum)
                
                MySQL.Async.execute('UPDATE stock SET quantity = quantity - @amount WHERE restaurant_id = @restaurant_id AND ingredient = @ingredient', {
                    ['@restaurant_id'] = restaurantId,
                    ['@ingredient'] = ingredient,
                    ['@amount'] = amountNum
                }, function(rowsChanged)
                    if rowsChanged > 0 then
                        TriggerClientEvent('ox_lib:notify', src, {
                            title = 'Stock Withdrawn',
                            description = 'You have withdrawn ' .. amountNum .. ' of ' .. itemData.name,
                            type = 'success',
                            showDuration = true,
                            duration = 10000
                        })
                    else
                        TriggerClientEvent('ox_lib:notify', src, {
                            title = 'Error',
                            description = 'Unable to withdraw stock. Please try again.',
                            type = 'error',
                            showDuration = true,
                            duration = 10000
                        })
                    end
                end)
            else
                TriggerClientEvent('ox_lib:notify', src, {
                    title = 'Error',
                    description = 'Invalid amount for stock withdrawal.',
                    type = 'error',
                    showDuration = true,
                    duration = 10000
                })
            end
        else
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Error',
                description = 'Item data not found for ingredient: ' .. ingredient,
                type = 'error',
                showDuration = true,
                duration = 10000
            })
        end
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Error',
            description = 'Player not found.',
            type = 'error',
            showDuration = true,
            duration = 10000
        })
    end
end)

function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

RegisterNetEvent('warehouse:acceptOrder')
AddEventHandler('warehouse:acceptOrder', function(orderId, restaurantId)
    local workerId = source

    MySQL.Async.fetchAll('SELECT * FROM orders WHERE id = @id', {
        ['@id'] = orderId,
    }, function(orderResults)
        if not orderResults or #orderResults == 0 then
            print("Error: No order found with ID:", orderId)
            return
        end

        local order = orderResults[1]

        local restaurantJob = Config.Restaurants[restaurantId] and Config.Restaurants[restaurantId].job

        local itemData = Config.Items[restaurantJob] and Config.Items[restaurantJob][order.ingredient:lower()]

        if not itemData then
            print("Error: Item not found for ingredient:", order.ingredient)
            return
        end

        MySQL.Async.fetchAll('SELECT quantity FROM warehouse_stock WHERE ingredient = @ingredient', {
            ['@ingredient'] = order.ingredient:lower(),
        }, function(stockResults)
            if not stockResults or #stockResults == 0 then
                print("Error: No stock information found for item:", order.ingredient)
                TriggerClientEvent('ox_lib:notify', workerId, {
                    title = 'Insufficient Stock',
                    description = 'Not enough stock for ' .. order.ingredient .. '.',
                    type = 'error',
                    position = 'top-right',
                    showDuration = true,
                    duration = 10000
                })
                return
            end

            local stock = stockResults[1].quantity

            if stock < order.quantity then
                TriggerClientEvent('ox_lib:notify', workerId, {
                    title = 'Insufficient Stock',
                    description = 'Not enough stock for ' .. order.ingredient .. '.',
                    type = 'error',
                    position = 'top-right',
                    showDuration = true,
                    duration = 10000
                })
                return
            end

            local orders = {
                {
                    id = order.id,
                    ownerId = order.owner_id,
                    itemName = itemData.name,
                    quantity = order.quantity,
                    totalCost = itemData.price * order.quantity,
                    restaurantId = order.restaurant_id
                }
            }

            TriggerClientEvent('warehouse:spawnVehicles', workerId, restaurantId, orders)

            -- Update the warehouse stock
            MySQL.Async.execute('UPDATE warehouse_stock SET quantity = quantity - @quantity WHERE ingredient = @ingredient', {
                ['@quantity'] = order.quantity,
                ['@ingredient'] = order.ingredient:lower(),
            }, function(rowsChanged)

                -- Update the order status to 'accepted'
                MySQL.Async.execute('UPDATE orders SET status = @status WHERE id = @id', {
                    ['@status'] = 'accepted',
                    ['@id'] = orderId,
                }, function(statusUpdateResult)

                    -- Notify the client about successful stock update and order acceptance
                    TriggerClientEvent('ox_lib:notify', workerId, {
                        description = 'Order accepted!',
                        type = 'success',
                        position = 'top-right',
                        showDuration = true,
                        duration = 10000
                    })
                end)
            end)
        end)
    end)
end)

-- Handle Order Denial
RegisterNetEvent('warehouse:denyOrder')
AddEventHandler('warehouse:denyOrder', function(orderId)
    TriggerClientEvent('ox_lib:notify', workerId, {
        title = 'Job Denied!',
        description = 'Orders marked as complete and stock updated successfully!',
        type = 'error',
        position = 'top-right',
        showDuration = true,
        duration = 10000
    })
end)

-- Event handler for resource start
AddEventHandler('onResourceStart', function(resourceName)
    -- Ensure this code runs only when the relevant resource starts
    if resourceName == GetCurrentResourceName() then

        -- Update orders with 'accepted' status to 'pending'
        MySQL.Async.execute('UPDATE orders SET status = @newStatus WHERE status = @oldStatus', {
            ['@newStatus'] = 'pending',
            ['@oldStatus'] = 'accepted'
        }, function(affectedRows)
        end)
    end
end)

RegisterServerEvent('farming:sellFruit')
AddEventHandler('farming:sellFruit', function(fruit, amount, targetCoords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = Player.Functions.GetItemByName(fruit)

    if item then
        if item.amount >= amount then
            local price = Config.ItemsFarming[fruit].price
            local total = amount * price

            Player.Functions.RemoveItem(fruit, amount)
            Player.Functions.AddMoney('cash', total)

            MySQL.Async.fetchAll('SELECT * FROM warehouse_stock WHERE ingredient = @ingredient', {
                ['@ingredient'] = fruit
            }, function(stockResults)
                if #stockResults > 0 then
                    MySQL.Async.execute('UPDATE warehouse_stock SET quantity = quantity + @quantity WHERE ingredient = @ingredient', {
                        ['@quantity'] = amount,
                        ['@ingredient'] = fruit
                    })
                else
                    MySQL.Async.execute('INSERT INTO warehouse_stock (ingredient, quantity) VALUES (@ingredient, @quantity)', {
                        ['@ingredient'] = fruit,
                        ['@quantity'] = amount
                    })
                end
            end)

            local data = {
                title = 'Sold ' .. amount .. ' ' .. fruit,
                description = 'for $' .. total,
                type = 'success',
                duration = 9000,
                position = 'top-right'
            }
            TriggerClientEvent('ox_lib:notify', src, data)
        else
            local data = {
                title = 'You don\'t have enough ' .. fruit .. 's',
                type = 'error',
                duration = 3000,
                position = 'top-right'
            }
            TriggerClientEvent('ox_lib:notify', src, data)
        end
    else
        local data = {
            title = 'You don\'t have any ' .. fruit .. 's',
            type = 'error',
            duration = 3000,
            position = 'top-right'
        }
        TriggerClientEvent('ox_lib:notify', src, data)
    end
end)
