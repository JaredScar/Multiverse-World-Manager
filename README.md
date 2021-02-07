# Multiverse-World-Manager

![Multiverse Logo](https://i.gyazo.com/fde6f4f7595f80ea1948bb4034a58f8b.png)

A FiveM Script taking advantage of routing buckets

## What is it?
Multiverse-World-Manager is part of a new series of FiveM scripts I will be releasing. It's essentially an idea I took from a very popular Minecraft plugin named `Multiverse`. This script essentially allows a server to have multiple `worlds` within their FiveM server. It's not actually different worlds, but different routing buckets (something the FiveM collective added a while ago). Players can change to different worlds depending on permissions and/or pick the world they want to load in at the loading screen (via AdaptiveCards).

I plan on releasing more Multiverse scripts, so make sure you keep a look out! The next script will probably be a Chat Manager to coordinates the chats between the different `worlds`.

## Screenshots
![Picture example of loading screen](https://i.gyazo.com/31a790a2a42ef879f47d9f72254a768a.jpg)

## Commands
`/world <worldName>` - This will teleport the player to  this world and set their routing bucket to it.

## Configuration
```lua
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
```
`RoutingBucket` can be any digit from 0 to 64. 0 is the default routing bucket, meaning it's essentially the default route for FiveM.

`Spawnpoint` is the coordinates of where the player should be teleported upon respawn and joining the world. Format: { `x`, `y`, `z` }

`PermissionRequired` is the ACE permission required to be able to join the world. You can put `false` if you want everyone to have access to the world.

## Download
https://github.com/JaredScar/Multiverse-World-Manager

