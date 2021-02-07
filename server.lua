---------------------------------
--- Custom Script (Exclusive) ---
---     created by Badger     ---
---------------------------------

WorldTracker = {};

RegisterNetEvent('Multiverse:GetWorld')
AddEventHandler('Multiverse:GetWorld', function(src, cb)
    local ids = ExtractIdentifiers(src);
    if (WorldTracker[ids.license] ~= nil) then 
        cb(WorldTracker[ids.license]);
    end
    cb("Normal");
end)

RegisterNetEvent('Multiverse:GetWorldBucketID')
AddEventHandler('Multiverse:GetWorldBucketID', function(src, cb)
    local ids = ExtractIdentifiers(src);
    if (WorldTracker[ids.license] ~= nil) then 
        cb(Config.Worlds[WorldTracker[ids.license]][1]);
    end
    cb(1);
end)

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }
  
    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
  
        --Convert it to a nice table.
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end  
    return identifiers
end

card = '{"type":"AdaptiveCard","$schema":"http://adaptivecards.io/schemas/adaptive-card.json","version":"1.2","body":[{"type":"Image","url":"{SERVER_BANNER}","horizontalAlignment":"Center"},{"type":"TextBlock","text":"{SERVER_TITLE}","wrap":true,"horizontalAlignment":"Center","separator":true,"height":"stretch","fontType":"Default","size":"Large","weight":"Bolder","color":"Light"},{"type":"TextBlock","text":"{DESCRIPTION}","wrap":true,"fontType":"Default","horizontalAlignment":"Center","color":"Light","size":"Medium"}{WORLDS},{"type":"ActionSet","actions":[{"type":"Action.OpenUrl","title":"Click to join Badger\'s Discord","style":"destructive","iconUrl":"https://i.gyazo.com/0904b936e8e30d0104dec44924bd2294.gif","url":"https://discord.com/invite/WjB5VFz"}]}]}'
-- Replace --{WORLDS}-- with:
worldFormat = ',{"type":"ActionSet","actions":[{"type":"Action.Submit","title":"{DISPLAY_NAME}","style":"positive","id":"{WORLD_NAME}"}]}';
card = card:gsub("{SERVER_TITLE}", Config.LoadingScreen.Title);
card = card:gsub("{DESCRIPTION}", Config.LoadingScreen.Description);
card = card:gsub("{SERVER_BANNER}", Config.LoadingScreen.Banner);

AddEventHandler('playerConnecting', function(name, setKickReason, def)
    def.defer();
    local user = source;
    local ids = ExtractIdentifiers(user);
    Citizen.Wait(2000); -- Necessary wait 
    local selected = false;
    local displayedWorlds = Config.LoadingScreen.DisplayedWorlds;
    local worlds = ""; 
    for displayName, vals in pairs(displayedWorlds) do 
        worldFormat = ',{"type":"ActionSet","actions":[{"type":"Action.Submit","title":"{DISPLAY_NAME}","style":"positive","id":"{WORLD_NAME}"}]}';
        local worldName = vals[1];
        local permissionReq = Config.Worlds[worldName][3];
        if permissionReq then 
            if IsPlayerAceAllowed(user, permissionReq) then 
                worldFormat = worldFormat:gsub("{DISPLAY_NAME}", displayName):gsub("{WORLD_NAME}", worldName);
                worlds = worlds .. worldFormat;
            end
        else 
            worldFormat = worldFormat:gsub("{DISPLAY_NAME}", displayName):gsub("{WORLD_NAME}", worldName);
            worlds = worlds .. worldFormat;
        end
    end
    local cardPres = card .. "";
    cardPres = cardPres:gsub("{WORLDS}", worlds);
    print(cardPres);
    if Config.LoadingScreen.Enabled then 
        while (not selected) do
            -- Display card to select
            def.presentCard(cardPres, function(data, rawData) 
                -- Check what they selected, if they clicked a button, then they selected something
                for displayName, vals in pairs(displayedWorlds) do
                    local worldName = vals[1];
                    if (data['submitId'] == worldName) then 
                        -- It was selected, set WorldTracker up for their new world, then teleport them on playerSpawn event 
                        WorldTracker[ids.license] = worldName;
                        selected = true;
                        print("[Multiverse-World-Manager] Set player `" .. GetPlayerName(user) .. "` to world `" .. worldName .. "`");
                    end
                end
            end)
            Citizen.Wait(1000);
        end
    end
    Citizen.Wait(0); -- Necessary wait
    def.done();
end)
AddEventHandler('playerDropped', function (reason) 
    local src = source;
    local ids = ExtractIdentifiers(src);
    WorldTracker[ids.license] = nil;
    local ids = ExtractIdentifiers(src);
end)

RegisterNetEvent('Multiverse:SpawnWorldTrigger')
AddEventHandler('Multiverse:SpawnWorldTrigger', function()
    local src = source;
    local ids = ExtractIdentifiers(src);
    if WorldTracker[ids.license] ~= nil then
        local worldName = WorldTracker[ids.license]; 
        local coords = Config.Worlds[worldName][2];
        SetPlayerRoutingBucket(src, Config.Worlds[worldName][1]);
        TriggerClientEvent("Multiverse:ChangeCoords", src, coords[1], coords[2], coords[3])
    end
end)

RegisterNetEvent('Multiverse:ChangeWorld')
AddEventHandler('Multiverse:ChangeWorld', function(worldName)
    local src = source;
    if Config.Worlds[worldName] ~= nil then 
        local permission = Config.Worlds[worldName][3];
        local coords = Config.Worlds[worldName][2];
        local ids = ExtractIdentifiers(src);
        if not permission then 
            SetPlayerRoutingBucket(src, Config.Worlds[worldName][1]);
            TriggerClientEvent("Multiverse:ChangeCoords", src, coords[1], coords[2], coords[3])
            WorldTracker[ids.license] = worldName;
            if Config.Messages['WORLD_CHANGED'] then 
                TriggerClientEvent('chatMessage', src, '^1[^6Multiverse-World-Manager^1] ^3 ' .. Config.Messages['WORLD_CHANGED']:gsub("{WORLD}", worldName));
            end
            return;
        end
        if IsPlayerAceAllowed(src, permission) then 
            -- Has valid permission, change their world
            SetPlayerRoutingBucket(src, Config.Worlds[worldName][1]);
            TriggerClientEvent("Multiverse:ChangeCoords", src, coords[1], coords[2], coords[3])
            WorldTracker[ids.license] = worldName;
            if Config.Messages['WORLD_CHANGED'] then 
                TriggerClientEvent('chatMessage', src, '^1[^6Multiverse-World-Manager^1] ^3 ' .. Config.Messages['WORLD_CHANGED']:gsub("{WORLD}", worldName));
            end
        else 
            -- No permission message
            TriggerClientEvent('chatMessage', src, "^1[^6Multiverse-World-Manager^1] ^3" .. Config.Messages['NO_PERMISSION']);
        end
    else 
        -- This world does not exist...
        TriggerClientEvent('chatMessage', src, "^1[^6Multiverse-World-Manager^1] ^3" .. Config.Messages['WORLD_DOES_NOT_EXIST']);
    end
end)
