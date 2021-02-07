---------------------------------
--- Custom Script (Exclusive) ---
---     created by Badger     ---
---------------------------------

AddEventHandler('playerSpawned', function()
    local src = source;
    TriggerServerEvent('Multiverse:SpawnWorldTrigger');
end)

RegisterNetEvent("Multiverse:ChangeCoords")
AddEventHandler("Multiverse:ChangeCoords", function(x, y, z)
    SetEntityCoords(GetPlayerPed(-1), x, y, z, false, false, false, false);
end)

RegisterCommand("world", function(source, args, rawCommand)
    local src = source;
    if #args == 0 then 
        -- Invalid amount of arguments
        return;
    end
    TriggerEvent('Multiverse:ChangeWorld', args[1]);
end)