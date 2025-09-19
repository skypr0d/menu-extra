Config = {}

Config.Framework = "QBCore" -- QBCore or ESX

Config.Extra = {
    {
        Coords = vector3(-1355.94, -2936.6, 13.55),
        Interact = "[~b~E~s~] Ouvrir le menu",
        DistView = 20.0,
        DistInteract = 3.0,
        Job = { "police"},
        Color = {red = 47, green = 139, blue = 181, alpha = 200},
        VehicleLists = { 'police','police2', 'police3', 'police4', 'policeb', 'policet', 'sheriff', 'sheriff2'},
    },
}

Config.Color = { -- https://wiki.rage.mp/wiki/Vehicle_Colors
    [1] = {color = 0, color2 = 0, name = "Noir"},
    [2] = {color = 27, color2 = 27, name = "Rouge"},
    [3] = {color = 50, color2 = 50, name = "Vert"},
    [4] = {color = 112, color2 = 112, name = "Blanc"},
    [5] = {color = 88, color2 = 88, name = "Jaune"},
    [6] = {color = 71, color2 = 71, name = "Violet"},
    [7] = {color = 38, color2 = 38, name = "Orange"},
    [8] = {color = 64, color2 = 64, name = "Bleu"},
}