local QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    if not Businesses.Businesses or type(Businesses.Businesses) ~= "table" then
        print("Error: Businesses.Businesses is not a valid table.")
        return
    end

    for job, details in pairs(Businesses.Businesses) do
        if not details.trays or type(details.trays) ~= "table" then
            print("Warning: 'trays' for job '" .. job .. "' is not a valid table.")
            details.trays = {}
        end

        if not details.storage or type(details.storage) ~= "table" then
            print("Warning: 'storage' for job '" .. job .. "' is not a valid table.")
            details.storage = {}
        end

        for trayIndex, _ in pairs(details.trays) do
            local trayId = "order-tray-" .. job .. '-' .. trayIndex
            local trayLabel = "Order Tray - " .. details.jobDisplay .. " - " .. trayIndex
            exports["ox_inventory"]:RegisterStash(trayId, trayLabel, 10, 50000)
        end

        for storageIndex, storageDetails in pairs(details.storage) do
            local storageId = "storage-" .. job .. '-' .. storageIndex
            local storageLabel = "Storage - " .. details.jobDisplay .. ' - ' .. storageIndex
            local slots = storageDetails.inventory.slots or 6
            local weight = (storageDetails.inventory.weight or 10) * 1000
            exports["ox_inventory"]:RegisterStash(storageId, storageLabel, slots, weight)
        end
    end
end)

RegisterServerEvent('v-businesses:GiveItem', function(info)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local iteminfo = info.iteminfo
    local quantity = info.quantity or 1

    if not iteminfo or not iteminfo.requiredItems then
        QBCore.Functions.Notify(src, "Invalid item info.", "error")
        return
    end

    if type(iteminfo.requiredItems) ~= "table" then
        QBCore.Functions.Notify(src, "Required items info is not a valid table.", "error")
        return
    end

    for _, reqItem in pairs(iteminfo.requiredItems) do
        local playerItem = player.Functions.GetItemByName(reqItem.item)
        if not playerItem or playerItem.amount < reqItem.amount * quantity then
            QBCore.Functions.Notify(src, "Insufficient required items to craft this item.", "error")
            return
        end
    end

    for _, reqItem in pairs(iteminfo.requiredItems) do
        player.Functions.RemoveItem(reqItem.item, reqItem.amount * quantity)
    end

    player.Functions.AddItem(iteminfo.item, quantity)
end)
