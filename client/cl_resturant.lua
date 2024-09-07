local QBCore = exports['qb-core']:GetCoreObject();

Citizen.CreateThread(function()
    for k, v in pairs(Businesses.Businesses) do
        local registers = v.registers
        local trays = v.trays
        local storage = v.storage
        local clockin = v.clockin
        local CookLoco = v.CookLoco
        local chairs = v.chairs

        if registers then
            for a, d in pairs(registers) do
                if d then
                    local length = 0.5
                    local width = 0.5
                    local height = 0.5

                    if Config.Target == 'qb' then
                        exports['qb-target']:AddBoxZone("register-" .. k .. "-" .. a, vector3(d.coords.x, d.coords.y, d.coords.z - 0.2), length, width,
                        {
                            name = "register-" .. k .. "-" .. a,
                            heading = d.coords.w,
                            debugPoly = false,
                            minZ = d.coords.z - 0.25,
                            maxZ = d.coords.z + height,
                        },
                        {
                            options = {
                                {
                                    event = "v-businesses:ChargeCustomer",
                                    icon = "fas fa-credit-card",
                                    label = "Access Register",
                                    job = k,
                                },
                                {
                                    event = "v-businesses:ShowMenu",
                                    icon = "fas fa-user-check",
                                    label = "Show Menu",
                                    registerJob = k,
                                },
                                {
                                    event = "v-businesses:Pay",
                                    icon = "fas fa-user-check",
                                    label = "Pay",
                                    registerJob = k,
                                },
                            },
                            distance = 2.0
                        })
                    elseif Config.Target == 'ox' then
                        exports.ox_target:addBoxZone({
                            coords = vector3(d.coords.x, d.coords.y, d.coords.z - 0.2),
                            size = vec3(length, width, height),
                            rotation = d.coords.w,
                            debug = false,
                            options = {
                                {
                                    name = "register-" .. k .. "-" .. a,
                                    icon = "fas fa-credit-card",
                                    label = "Access Register",
                                    onSelect = function()
                                        TriggerEvent("v-businesses:ChargeCustomer", {registerJob = k})
                                    end,
                                    groups = k,
                                },
                                {
                                    name = "register-" .. k .. "-" .. a,
                                    icon = "fas fa-user-check",
                                    label = "Show Menu",
                                    onSelect = function()
                                        TriggerEvent("v-businesses:ShowMenu", {registerJob = k})
                                    end,
                                },
                                {
                                    name = "register-" .. k .. "-" .. a,
                                    icon = "fas fa-user-check",
                                    label = "Pay",
                                    onSelect = function()
                                        TriggerEvent("v-businesses:Pay", {registerJob = k})
                                    end,
                                }
                            },
                            distance = 2.0
                        })
                    end

                    if d.Prop then
                        local registerProp = CreateObject(GetHashKey("prop_till_01"), d.coords.x, d.coords.y, d.coords.z, false, false, false)
                        SetEntityHeading(registerProp, d.coords.w)
                        FreezeEntityPosition(registerProp, true)
                    end
                end
            end
        end

        if trays then
            for a, d in pairs(trays) do
                if d then
                    local length = 0.5
                    local width = 0.5
                    local height = 0.25

                    if Config.Target == 'qb' then
                        exports['qb-target']:AddBoxZone("tray-" .. k .. "-" .. a, vector3(d.coords.x, d.coords.y, d.coords.z - 0.62), length, width,
                        {
                            name = "tray-" .. k .. "-" .. a,
                            heading = d.coords.w,
                            debugPoly = false,
                            minZ = d.coords.z - 0.25,
                            maxZ = d.coords.z + height,
                        },
                        {
                            options = {
                                {
                                    event = "v-businesses:OpenTray",
                                    icon = "fas fa-basket-shopping",
                                    label = "Open Tray",
                                    trayId = a,
                                    trayJob = k,
                                },
                            },
                            distance = 2.0
                        })
                    elseif Config.Target == 'ox' then
                        exports.ox_target:addBoxZone({
                            coords = vector3(d.coords.x, d.coords.y, d.coords.z - 0.62),
                            size = vec3(length, width, height),
                            rotation = d.coords.w,
                            debug = false,
                            options = {
                                {
                                    name = "tray-" .. k .. "-" .. a,
                                    icon = "fas fa-basket-shopping",
                                    label = "Open Tray",
                                    onSelect = function()
                                        -- Ensure parameters are passed as an object
                                        TriggerEvent("v-businesses:OpenTray", { trayId = a, trayJob = k })
                                    end,
                                },
                            },
                            distance = 2.0
                        })
                    end
                end
            end
        end

        if clockin then
            if Config.Target == 'qb' then
                exports['qb-target']:AddBoxZone("clockin-" .. k, vector3(clockin.coords.x, clockin.coords.y, clockin.coords.z - 0.62), clockin.dimensions.length, clockin.dimensions.width,
                {
                    name = "clockin-" .. k,
                    heading = clockin.coords.w,
                    debugPoly = false,
                    minZ = clockin.coords.z - clockin.dimensions.height,
                    maxZ = clockin.coords.z + clockin.dimensions.height,
                },
                {
                    options = {
                        {
                            event = "v-businesses:ToggleClockIn",
                            icon = "fas fa-clock",
                            label = "Clock In/Out",
                            job = k
                        },
                    },
                    distance = 2.0
                })
            elseif Config.Target == 'ox' then
                exports.ox_target:addBoxZone({
                    coords = vector3(clockin.coords.x, clockin.coords.y, clockin.coords.z - 0.62),
                    size = vec3(clockin.dimensions.length, clockin.dimensions.width, clockin.dimensions.height),
                    rotation = clockin.coords.w,
                    debug = false,
                    options = {
                        {
                            name = "clockin-" .. k,
                            icon = "fas fa-clock",
                            label = "Clock In/Out",
                            groups = k,
                            onSelect = function()
                                TriggerEvent("v-businesses:ToggleClockIn", k)
                            end,
                        },
                    },
                    distance = 2.0
                })
            end
        end

        if storage then
            for a, d in pairs(storage) do
                if d then
                    local height = d.height or 1.0

                    if Config.Target == 'qb' then
                        exports['qb-target']:AddBoxZone("storage-" .. k .. "-" .. a, vector3(d.coords.x, d.coords.y, d.coords.z - 0.62), d.width or 1.5, d.length or 0.6,
                        {
                            name = "storage-" .. k .. "-" .. a,
                            heading = d.coords.w,
                            debugPoly = false,
                            minZ = d.coords.z - height,
                            maxZ = d.coords.z + height,
                        },
                        {
                            options = {
                                {
                                    event = "v-businesses:OpenStorage",
                                    icon = "fas fa-dolly",
                                    label = d.targetLabel,
                                    job = k,
                                    storageId = a,
                                    storageJob = k
                                },
                            },
                            distance = 2.0
                        })
                    elseif Config.Target == 'ox' then
                        exports.ox_target:addBoxZone({
                            coords = vector3(d.coords.x, d.coords.y, d.coords.z - 0.62),
                            size = vec3(d.width or 1.5, d.length or 0.6, height),
                            rotation = d.coords.w,
                            debug = false,
                            options = {
                                {
                                    name = "storage-" .. k .. "-" .. a,
                                    icon = "fas fa-dolly",
                                    label = d.targetLabel,
                                    groups = k, 
                                    onSelect = function()
                                        TriggerEvent("v-businesses:OpenStorage", { storageJob = k, storageId = a })
                                    end,
                                },
                            },
                            distance = 2.0
                        })
                    end
                end
            end
        end

        if CookLoco then
            for a, d in pairs(CookLoco) do
                if d then
                    local height = d.height or 0.35
                    local length = d.length or 1.5
                    local width = d.width or 0.6

                    if Config.Target == 'qb' then
                        exports['qb-target']:AddBoxZone("CookLoco-" .. k .. "-" .. a, vector3(d.coords.x, d.coords.y, d.coords.z - 0.52), length, width,
                        {
                            name = "CookLoco-" .. k .. "-" .. a,
                            heading = d.coords.w,
                            debugPoly = false,
                            minZ = d.coords.z - height,
                            maxZ = d.coords.z + height,
                        },
                        {
                            options = {
                                {
                                    event = "v-businesses:PrepareFood",
                                    icon = "fas fa-utensils",
                                    label = d.targetLabel,
                                    job = k,
                                    index = a
                                },
                            },
                            distance = 2.0
                        })
                    elseif Config.Target == 'ox' then
                        exports.ox_target:addBoxZone({
                            coords = vector3(d.coords.x, d.coords.y, d.coords.z - 0.52),
                            size = vec3(length, width, height),
                            rotation = d.coords.w,
                            debug = false,
                            options = {
                                {
                                    name = "CookLoco-" .. k .. "-" .. a,
                                    icon = "fas fa-utensils",
                                    label = d.targetLabel,
                                    groups = k,
                                    onSelect = function()
                                        TriggerEvent("v-businesses:PrepareFood", { job = k, index = a })
                                    end,
                                },
                            },
                            distance = 2.0
                        })
                    end
                end
            end
        end

        if chairs then
            for a, chair in pairs(chairs) do
                if chair then
                    local size = 0.6
                    local height = 0.25

                    if Config.Target == 'qb' then
                        exports['qb-target']:AddBoxZone("chair-" .. k .. "-" .. a, vector3(chair.coords.x, chair.coords.y, chair.coords.z - 0.65), size, size,
                        {
                            name = "chair-" .. k .. "-" .. a,
                            heading = chair.coords.w,
                            debugPoly = false,
                            minZ = chair.coords.z - height,
                            maxZ = chair.coords.z + height,
                        },
                        {
                            options = {
                                {
                                    event = "v-businesses:SitChair",
                                    chairId = a,
                                    chairJob = k,
                                    icon = "fas fa-couch",
                                    label = "Sit Chair",
                                    coords = vector3(chair.coords.x, chair.coords.y, chair.coords.z),
                                },
                            },
                            distance = 2.5
                        })
                    elseif Config.Target == 'ox' then
                        exports.ox_target:addBoxZone({
                            coords = vector3(chair.coords.x, chair.coords.y, chair.coords.z - 0.65),
                            size = vec3(size, size, height),
                            rotation = chair.coords.w,
                            debug = false,
                            options = {
                                {
                                    name = "chair-" .. k .. "-" .. a,
                                    icon = "fas fa-couch",
                                    label = "Sit Chair",
                                    onSelect = function()
                                        TriggerEvent("v-businesses:SitChair", {
                                            coords = chair.coords,
                                            chairJob = k
                                        })
                                    end,
                                },
                            },
                            distance = 2.5
                        })
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    for businessName, business in pairs(Businesses.Businesses) do
        if business.blip then
            local blip = AddBlipForCoord(business.clockin.coords.x, business.clockin.coords.y, business.clockin.coords.z)
            SetBlipSprite(blip, business.blip.sprite) 
            SetBlipScale(blip, business.blip.scale) 
            SetBlipColour(blip, business.blip.color) 
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(business.jobDisplay)
            EndTextCommandSetBlipName(blip)
            SetBlipAsShortRange(blip, true)
        end
    end
end)

RegisterNetEvent('v-businesses:ChargeCustomer', function(info)
    TriggerEvent(Businesses.ResturantBillingEvent)
end)

RegisterNetEvent('v-businesses:Pay', function(info)
    TriggerEvent(Businesses.CustomerBillingEvent)
end)

RegisterNetEvent('v-businesses:OpenTray')
AddEventHandler('v-businesses:OpenTray', function(info)
    -- Debugging: Print the type and contents of `info`
    print("Type of info: ", type(info))
    print("Contents of info: ", json.encode(info)) -- Requires a JSON library or similar for pretty-printing

    if type(info) == 'table' and info.trayJob and info.trayId then
        local jobName = info.trayJob
        local trayId = info.trayId
        local stashName = "order-tray-" .. jobName .. "-" .. trayId
        exports["ox_inventory"]:openInventory('stash', stashName)
    else
        print("Error: Invalid data received for OpenTray event.")
    end
end)

RegisterNetEvent('v-businesses:OpenStorage')
AddEventHandler('v-businesses:OpenStorage', function(info)
    -- Print type and contents of `info` to diagnose the issue
    print("Type of info: ", type(info))
    print("Contents of info: ", json.encode(info))  -- Use a JSON library or similar for pretty-printing

    if type(info) == 'table' and info.storageJob and info.storageId then
        local jobName = info.storageJob
        local storageId = info.storageId
        local stashName = "storage-" .. jobName .. "-" .. storageId
        exports["ox_inventory"]:openInventory('stash', stashName)
    else
        print("Error: Invalid data received for OpenStorage event.")
    end
end)

RegisterNetEvent('v-businesses:ToggleClockIn', function(info)
    if lib.progressCircle({
        duration = 3000,
        label = 'Toggling Duty',
        position = 'bottom',
        disable = {
            move = true,
            car = true,
            mouse = false,
            combat = true,
        },
        anim = {
            dict = 'amb@world_human_clipboard@male@idle_a',
            clip = 'idle_a'
        },
    }) then
        TriggerServerEvent('QBCore:ToggleDuty')
    end
end)

RegisterNetEvent('v-businesses:PrepareFood')
AddEventHandler('v-businesses:PrepareFood', function(info)
    -- Check if `info` is a table and contains the expected fields
    if type(info) == 'table' and info.job and info.index then
        local job = info.job
        local index = info.index
        local CookLoco = Businesses.Businesses[job].CookLoco[index]

        if not CookLoco then
            lib.notify({
                title = 'Invalid Preparation Table',
                type = 'error'
            })
            return
        end

        local options = {}

        for _, item in pairs(CookLoco.items) do
            local hasItems = true
            local requirements = "Requirements:\n"

            if item.requiredItems then
                for _, req in pairs(item.requiredItems) do
                    local itemInfo = QBCore.Shared.Items[req.item]
                    local itemDisplayName = itemInfo and itemInfo.label or req.item
                    requirements = requirements .. req.amount .. "x " .. itemDisplayName .. "\n"
                    if exports.ox_inventory:GetItemCount(req.item) < req.amount then
                        hasItems = false
                    end
                end
            else
                requirements = "Requirements: None"
            end

            local iteminfo = exports.ox_inventory:Items(item.item)
            local itemName = iteminfo and iteminfo.label or item.item
            local itemID = iteminfo and iteminfo.name or item.item

            table.insert(options, {
                title = itemName,
                description = requirements,
                image = 'nui://ox_inventory/web/images/' .. itemID .. '.png',
                disabled = not hasItems,
                event = "btrp-business:inputAmount",
                args = { iteminfo = item, index = index }
            })
        end

        lib.registerContext({
            id = 'food_preparation_menu',
            title = 'Prepare Food',
            options = options,
            onExit = function()
                ClearPedTasks(PlayerPedId())
            end
        })

        lib.showContext('food_preparation_menu')
    else
        print("Error: Invalid data received for PrepareFood event.")
        print("Received info:", type(info), json.encode(info)) 
    end
end)

RegisterNetEvent('btrp-business:inputAmount', function(info)
    local iteminfo = info.iteminfo
    local input = lib.inputDialog('Cooking', {
        { type = 'number', label = 'Food Quantity', description = 'How many would you like to make?', min = 1, max = 10, icon = 'hashtag' }
    })

    local quantity = tonumber(input[1])

    if not quantity then
        ClearPedTasks(PlayerPedId())
        lib.notify({
            title = 'Invalid Input',
            type = 'error'
        })
        return
    end

    local hasAllRequiredItems = true
    local requirements = "Requirements: "

    if iteminfo.requiredItems then
        for _, req in pairs(iteminfo.requiredItems) do
            local totalRequired = req.amount * quantity
            local itemDisplayName = exports.ox_inventory:Items(req.item).label or req.item
            requirements = requirements .. totalRequired .. "x " .. itemDisplayName .. " "

            if exports.ox_inventory:GetItemCount(req.item) < totalRequired then
                hasAllRequiredItems = false
            end
        end
    end

    if not hasAllRequiredItems then
        lib.notify({
            title = 'Insufficient Items',
            description = 'You do not have enough items. Required: ' .. requirements,
            type = 'error'
        })
        return
    end

    TriggerEvent('v-businesses:CompletePreparingFood', { iteminfo = iteminfo, index = info.index, quantity = quantity })
end)

RegisterNetEvent('v-businesses:CompletePreparingFood', function(info)
    local iteminfo = info.iteminfo
    local index = info.index
    local quantity = info.quantity

    for i = 1, quantity do
        if lib.progressCircle({
            duration = iteminfo.time,
            label = iteminfo.progressLabel,
            position = 'bottom',
            disable = {
                move = true,
                car = true,
                mouse = false,
                combat = true
            },
            anim = {
                dict = 'mini@repair',
                clip = 'fixing_a_ped'
            }
        }) then
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent('v-businesses:GiveItem', { iteminfo = iteminfo, quantity = 1 })
            Citizen.Wait(1000)
        end
    end

    TriggerEvent('v-businesses:PrepareFood', { index = index })
end)

RegisterNetEvent('v-businesses:SitChair', function(info)
    local ped = PlayerPedId()
    local coords = info.coords

    if not coords or not coords.x or not coords.y or not coords.z then
        lib.notify({
            title = 'Invalid chair coordinates.',
            type = 'error'
        })
        return
    end

    -- Determine Z-coordinate adjustment based on the target type
    local adjustedCoords
    if Config.Target == 'ox' then
        adjustedCoords = vector3(coords.x, coords.y, coords.z - 0.5) -- Adjust this offset as needed
    else
        adjustedCoords = vector3(coords.x, coords.y, coords.z)
    end

    -- Check distance to chair
    if #(GetEntityCoords(ped) - adjustedCoords) > 2.0 then
        lib.notify({
            title = 'You are too far from the chair.',
            type = 'error'
        })
        return
    end

    -- Check for nearby players
    local playersNearby = QBCore.Functions.GetPlayersFromCoords(adjustedCoords, 0.5)
    local seatTaken = false
    for _, player in ipairs(playersNearby) do
        if player ~= PlayerId() and IsPedSittingInAnyVehicle(GetPlayerPed(player)) then
            seatTaken = true
            break
        end
    end

    if seatTaken then
        lib.notify({
            title = 'This seat is taken.',
            type = 'error'
        })
        return
    end

    -- Determine chair facing direction
    local business = info.chairJob
    local chairFacing = 0.0

    if Businesses.Businesses[business] and Businesses.Businesses[business].chairs then
        for _, chair in ipairs(Businesses.Businesses[business].chairs) do
            local chairCoords = vector3(chair.coords.x, chair.coords.y, chair.coords.z)
            local distance = #(adjustedCoords - chairCoords)

            if distance < 1.0 then
                chairFacing = chair.coords.w
                break
            end
        end
    else
        lib.notify({
            title = 'Business or chair info not found.',
            type = 'error'
        })
        return
    end

    -- Move to the chair and start the sitting animation
    TaskGoStraightToCoord(ped, adjustedCoords.x, adjustedCoords.y, adjustedCoords.z, 1.0, 2000, chairFacing, 0.1)

    Citizen.Wait(1200)

    TaskStartScenarioAtPosition(ped, "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", adjustedCoords.x, adjustedCoords.y, adjustedCoords.z, chairFacing, 0, true, true)

    lib.notify({
        title = 'You sat down on the chair.',
        type = 'success'
    })
end)

RegisterNetEvent('v-businesses:ShowMenu')
AddEventHandler('v-businesses:ShowMenu', function(info)
    -- Handle missing info scenario
    if not info then
        print("No info provided")
        return
    end

    -- Default values to avoid nil indexing
    local businessName = info.registerJob or info.storageJob or info.trayJob or info.CookLocoJob
    local business = Businesses.Businesses[businessName]

    if not business then
        print("Business not found")
        return
    end

    local imageUrl = business.menu

    -- Debugging info
    print("Image URL: " .. (imageUrl or "No URL"))

    lib.alertDialog({
        header = business.jobDisplay .. ' Menu' or "Business Image",
        content = '![Photo ID Image](' .. imageUrl .. ')\n\nUse this image?',
        centered = true,
        cancel = true,
        size = 'xl',
        labels = {
            confirm = 'OK'
        }
    })
end)

-- Seller - auto goes to warehouse stock

Citizen.CreateThread(function()
    if SellerBlip then
        RemoveBlip(SellerBlip)
    end

    SellerBlip = AddBlipForCoord(Config.SellerBlip.coords.x, Config.SellerBlip.coords.y, Config.SellerBlip.coords.z)
    SetBlipSprite(SellerBlip, Config.SellerBlip.blipSprite)
    SetBlipDisplay(SellerBlip, 4)
    SetBlipScale(SellerBlip, Config.SellerBlip.blipScale)
    SetBlipColour(SellerBlip, Config.SellerBlip.blipColor)
    SetBlipAsShortRange(SellerBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.SellerBlip.label)
    EndTextCommandSetBlipName(SellerBlip)
end)

Citizen.CreateThread(function()
    local pedModel = GetHashKey(Config.PedModel)
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(500)
    end

    local ped = CreatePed(4, pedModel, Config.Location.coords.x, Config.Location.coords.y, Config.Location.coords.z, Config.Location.heading, false, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetModelAsNoLongerNeeded(pedModel)

    if Config.Target == 'qb' then
        exports['qb-target']:AddBoxZone('fruit_sell_ped', Config.Location.coords, 2.0, 2.0, {
            name = 'fruit_sell_ped',
            heading = Config.Location.heading,
            debugPoly = false,
            minZ = Config.Location.coords.z - 1.0,  -- Adjust Z coordinates as needed
            maxZ = Config.Location.coords.z + 1.0
        }, {
            options = {
                {
                    type = "client",
                    event = "farming:openFruitMenu",
                    icon = "fas fa-shopping-basket",
                    label = "Sell Items"
                },
            },
            distance = 2.0
        })
    elseif Config.Target == 'ox' then
        exports.ox_target:addBoxZone({
            coords = Config.Location.coords,
            size = vec3(2.0, 2.0, 1.0),
            rotation = Config.Location.heading,
            debug = false,
            options = {
                {
                    name = 'fruit_sell_ped',
                    icon = "fas fa-shopping-basket",
                    label = "Sell Items",
                    onSelect = function()
                        TriggerEvent("farming:openFruitMenu")
                    end
                },
            },
            distance = 2.0
        })
    end
end)

RegisterNetEvent('farming:openFruitMenu')
AddEventHandler('farming:openFruitMenu', function()
    local fruits = {}

    -- Function to filter fruits based on search query
    local function filterFruits(query)
        local filteredFruits = {}
        for fruit, info in pairs(Config.ItemsFarming) do
            if info.label and string.find(string.lower(info.label), string.lower(query)) then
                local menuItem = {
                    title = info.label,
                    description = 'Sell some ' .. info.label .. "'s",
                    icon = 'fas fa-hand',
                    onSelect = function()
                        TriggerEvent('farming:selectFruit', { fruit = fruit })
                    end
                }
                table.insert(filteredFruits, menuItem)
            end
        end
        return filteredFruits
    end

    -- Function to create the menu with the option to search
    local function createMenu(searchQuery)
        local options = {}

        -- Add the search button at the top
        table.insert(options, {
            title = 'Search',
            description = 'Search for an item to sell',
            icon = 'fas fa-search',
            onSelect = function()
                -- Show the input dialog for search
                local input = lib.inputDialog('Search Items', {
                    { type = 'input', label = 'Enter Item name' }
                })

                -- If input is not canceled, filter and re-open the menu
                if input and input[1] then
                    createMenu(input[1])
                end
            end
        })

        -- Add the fruits based on the current search query
        local filteredFruits = filterFruits(searchQuery or '')
        for _, menuItem in ipairs(filteredFruits) do
            table.insert(options, menuItem)
        end

        -- Register and show the menu
        lib.registerContext({
            id = 'farming_fruit_menu_ox',
            title = 'Fruit Salesman',
            options = options
        })

        lib.showContext('farming_fruit_menu_ox')
    end

    -- Create and show the menu initially without any search query
    createMenu()
end)

RegisterNetEvent('farming:selectFruit')
AddEventHandler('farming:selectFruit', function(data)
    local fruit = data.fruit

    -- Use ox_lib input dialog for both cases
    local dialog = lib.inputDialog("Sell " .. Config.ItemsFarming[fruit].label, {
        {
            type = "number",
            label = "Amount to sell",
            default = "1",
        }
    }, { allowCancel = true })

    if dialog then
        local amount = tonumber(dialog[1])

        if amount and amount >= 1 then
            -- Use ox_lib progress circle for the selling animation
            lib.progressCircle({
                duration = Config.SellProgress,
                label = 'Selling ' .. fruit,
                canCancel = false,
                position = 'bottom',
                disable = {
                    car = true,
                    move = true,
                    combat = true,
                    sprint = true,
                },
                anim = {
                    dict = Config.SellingAnimDict,
                    clip = Config.SellingAnimName
                },
            })
            TriggerServerEvent('farming:sellFruit', fruit, amount)
        else
            -- Use ox_lib notification for invalid amount
            lib.notify({
                title = 'Invalid Amount',
                description = 'Please enter a valid number greater than or equal to 1',
                type = 'error'
            })
        end
    else
        -- Use ox_lib notification for sale cancellation
        lib.notify({
            title = 'Sale canceled',
            description = 'Please enter a valid amount to sell',
            type = 'error'
        })
    end
end)