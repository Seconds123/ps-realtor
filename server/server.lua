local ESX = exports['es_extended']:getSharedObject()

local function GetOfflinePlayerName(identifier)
    local user = MySQL.query.await("SELECT firstname, lastname FROM users WHERE identifier = ?", { identifier })

    if user and user[1] then
        return user[1].firstname .. ' ' .. user[1].lastname
    else
        return "Unknown"
    end
end

RegisterNetEvent("bl-realtor:server:updateProperty", function(type, property_id, data)
    -- Job check
    local src = source
    local PlayerData = ESX.GetPlayerFromId(src)
    if not RealtorJobs[PlayerData.job.name] then return false end

    data.realtorSrc = src
    -- Update property
    TriggerEvent("ps-housing:server:updateProperty", type, property_id, data)
end)

RegisterNetEvent("bl-realtor:server:registerProperty", function(data)
    -- Job check
    local src = source
    local PlayerData = ESX.GetPlayerFromId(src)
    if not RealtorJobs[PlayerData.job.name] then return false end

    data.realtorSrc = src
    -- Register property
    TriggerEvent("ps-housing:server:registerProperty", data)
end)

RegisterNetEvent("bl-realtor:server:addTenantToApartment", function(data)
    -- Job check
    local src = source
    local PlayerData = ESX.GetPlayerFromId(src)
    if not RealtorJobs[PlayerData.job.name] then return false end

    data.realtorSrc = src
    -- Add tenant
    TriggerEvent("ps-housing:server:addTenantToApartment", data)
end)

lib.callback.register("bl-realtor:server:getNames", function(source, data)
    local src = source
    local PlayerData = ESX.GetPlayerFromId(src)
    if not RealtorJobs[PlayerData.job.name] then return false end

    local names = {}
    for i = 1, #data do
        local target = ESX.GetPlayerFromIdentifier(data[i]) or GetOfflinePlayerName(data[i])
        if target then
            names[#names + 1] = target.PlayerData.charinfo.firstname .. " " .. target.PlayerData.charinfo.lastname
        else
            names[#names + 1] = "Unknown"
        end
    end

    return names
end)

if Config.UseItem then
    ESX.RegisterUsableItem(Config.ItemName, function(source)
        local src = source
        TriggerClientEvent("bl-realtor:client:toggleUI", src)
    end)
end
