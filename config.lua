---------------------------------
--- Custom Script (Exclusive) ---
---     created by Badger     ---
---------------------------------
Config = {
    Worlds = { -- ["WorldName"] = {RoutingBucket, Spawnpoint, PermissionRequired},
        ["Normal"] = {0, { 311.22, 3457.60, 36.15 }, false}, -- DO NOT REMOVE
        ["Donator"] = {1, { -269.34, 6628.99, 7.55 }, "Permission.Donator"},
        ["PVP"] = {2, { -1037.48, -2737.40, 20.17 }, false},
        ["PVP2"] = {3, { 1967.2, 3736.52, 32.21 }, false},
    },
    Messages = {
        ["WORLD_CHANGED"] = "Your world has been changed to {WORLD}", -- Set this to false if you do not want this message to be a thing
        ["WORLD_DOES_NOT_EXIST"] = "This world does not exist!",
        ["NO_PERMISSION"] = "You do not have permission to access this world..."
    },
    LoadingScreen = {
        Enabled = true,
        Banner = "https://i.gyazo.com/fde6f4f7595f80ea1948bb4034a58f8b.png",
        Title = "Welcome to our server!",
        Description = "Select the world you would like to join down below...",
        DisplayedWorlds = {
            ["RP World"] = {"Normal"},
            ["Donator World"] = {"Donator"},
            ["PVP World"] = {"PVP"},
        },
    }
}