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

                    if d.Prop then
                        local registerProp = CreateObject(GetHashKey("prop_till_01"), d.coords.x, d.coords.y, d.coords.z, false, false, false)
                        SetEntityHeading(register, d.coords.w)
                        FreezeEntityPosition(register, true)
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
                        }
                    )
                end
            end
        end

        if clockin then
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
                }
            )
        end

        if storage then
            for a, d in pairs(storage) do
                if d then
                    local height = d.height or 1.0 
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
                        }
                    )
                end
            end
        end        

        if CookLoco then
            for a, d in pairs(CookLoco) do
                if d then
                    exports['qb-target']:AddBoxZone("CookLoco-" .. k .. "-" .. a, vector3(d.coords.x, d.coords.y, d.coords.z - 0.52), d.length or 1.5, d.width or 0.6,
                        {
                            name = "CookLoco-" .. k .. "-" .. a,
                            heading = d.coords.w,
                            debugPoly = false,
                            minZ = d.coords.z - (d.height or 0.35),
                            maxZ = d.coords.z + (d.height or 0.35),
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
                        }
                    )
                end
            end
        end

        if chairs then
            for a, chair in pairs(chairs) do
                if chair then
                    exports['qb-target']:AddBoxZone("chair-" .. k .. "-" .. a, vector3(chair.coords.x, chair.coords.y, chair.coords.z - 0.65), 0.6, 0.6,
                        {
                            name = "chair-" .. k .. "-" .. a,
                            heading = chair.coords.w,
                            debugPoly = false,
                            minZ = chair.coords.z - 0.25,
                            maxZ = chair.coords.z + 0.25,
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
                        }
                    )
                end
            end
        end
    end
end)

RegisterNetEvent('v-businesses:ChargeCustomer', function(info)
    TriggerEvent(Businesses.ResturantBillingEvent)
end)

RegisterNetEvent('v-businesses:Pay', function(info)
    TriggerEvent(Businesses.CustomerBillingEvent)
end)

RegisterNetEvent('v-businesses:OpenTray', function(info)
    local jobName = info.trayJob
    local trayId = info.trayId
    local stashName = "order-tray-" .. jobName .. "-" .. trayId
    exports["ox_inventory"]:openInventory('stash', stashName)
end)

RegisterNetEvent('v-businesses:OpenStorage', function(info)
    local jobName = info.storageJob
    local storageId = info.storageId
    local stashName = "storage-" .. jobName .. "-" .. storageId
    exports["ox_inventory"]:openInventory('stash', stashName)
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

RegisterNetEvent('v-businesses:PrepareFood', function(info)
    local job = QBCore.Functions.GetPlayerData().job.name
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
    local coords = vector3(info.coords.x, info.coords.y, info.coords.z)

    if #(GetEntityCoords(ped) - coords) > 2.0 then
        lib.notify({
            title = 'You are too far from the chair.',
            type = 'error'
        })
        return
    end

    local playersNearby = QBCore.Functions.GetPlayersFromCoords(coords, 0.5)
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

    local business = info.chairJob or "burgershot"
    local chairFacing = 0.0

    if Businesses.Businesses[business] and Businesses.Businesses[business].chairs then
        for _, chair in ipairs(Businesses.Businesses[business].chairs) do
            local chairCoords = vector3(chair.coords.x, chair.coords.y, chair.coords.z)
            local distance = #(coords - chairCoords)

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

    TaskGoStraightToCoord(ped, coords.x, coords.y, coords.z, 1.0, 2000, chairFacing, 0.1)

    Citizen.Wait(1200)

    TaskStartScenarioAtPosition(ped, "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", coords.x, coords.y, coords.z, chairFacing, 0, true, true)

    lib.notify({
        title = 'You sat down on the chair.',
        type = 'success'
    })
end)

RegisterNetEvent('v-businesses:ShowMenu')
AddEventHandler('v-businesses:ShowMenu', function(info)
    local businessName = info.registerJob or info.storageJob or info.trayJob or info.CookLocoJob
    local business = Businesses.Businesses[businessName]

    if not business then
        print("Business not found")
        return
    end

    local imageUrl = business.menu

    print("Image URL: " .. imageUrl)

    local alert = lib.alertDialog({
        header = business.jobDisplay .. ' Menu' or "Business Image",
        content = '![Photo ID Image](' .. imageUrl .. ')\n\nUse this image?',
        centered = true,
        cancel = true,
        size = 'xl',  -- Choose the size that fits best, e.g., 'xs', 'sm', 'md', 'lg', 'xl'
        labels = {
            cancel = 'Close',
            confirm = 'OK'
        }
    })

    print(alert)
end)
