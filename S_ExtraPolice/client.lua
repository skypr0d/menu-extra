if Config.Framework == "ESX" then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == "QBCore" then
    QBCore = exports['qb-core']:GetCoreObject()
end

local ExtraMenu = false

local function Notify(message)
    if Config.Framework == "ESX" then
        ESX.ShowNotification(message)
    elseif Config.Framework == "QBCore" then
        TriggerEvent('QBCore:Notify', message)
    end
end

function DrawText3Ds(x, y, z, text)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*3
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
        SetTextScale(0.0*scale, 0.40*scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        SetDrawOrigin(x,y,z, 0)
        DrawText(0.0, 0.0)
        ClearDrawOrigin()
end

if Config.Framework == "ESX" then
    Citizen.CreateThread(function()
        while ESX.GetPlayerData().job == nil do Wait(10) end
        PlayerData = ESX.GetPlayerData()
        PlayerJobName = PlayerData.job.name
    end)

    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer)
        PlayerData = xPlayer
        PlayerJobName = PlayerData.job.name
    end)

    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(job)
        PlayerData.job = job
        PlayerJobName = PlayerData.job.name
    end)

elseif Config.Framework == "QBCore" then

    AddEventHandler('onResourceStart', function(resource)
        if resource == GetCurrentResourceName() then
            PlayerData = QBCore.Functions.GetPlayerData()
            PlayerJobName = PlayerData.job.name
        end
    end)

    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        PlayerData = QBCore.Functions.GetPlayerData()
        PlayerJobName = PlayerData.job.name
    end)

    RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
        PlayerJobName = JobInfo.name
    end)
end

CreateThread(function()
    while true do 
        AuthorizedMenu, PlayerJobVerif, VehicleVerif = false, false, false
        local pCoords = GetEntityCoords(PlayerPedId())
        for k,v in pairs(Config.Extra) do
            local dist = #(pCoords - v.Coords)
            if dist <= v.DistView then
                if not IsPedSittingInAnyVehicle(PlayerPedId()) then break end 

                for _,conf_job in pairs(Config.Extra[k].Job) do if conf_job == PlayerJobName then PlayerJobVerif = true end end
                if not PlayerJobVerif then break end

                for _,conf_vehicle in pairs(Config.Extra[k].VehicleLists) do if GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false)) == GetHashKey(conf_vehicle) then VehicleVerif = true end end
                if not VehicleVerif then break end

                AuthorizedMenu = true 
                DrawMarker(36, v.Coords.x, v.Coords.y, v.Coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.5, 2.5, 2.5, v.Color.red, v.Color.green, v.Color.blue, v.Color.alpha, false, true, 2, false, nil, nil, false )
                if dist <= v.DistInteract then
                    DrawText3Ds(v.Coords.x, v.Coords.y, v.Coords.z + 1.2, v.Interact)
                    if IsControlJustReleased(0, 38) then
                        if not ExtraMenu then MenuExtra() else Notify("~r~Vous avez déjà le menu d'ouvert") end
                    end
                end

            end
        end

        if AuthorizedMenu then Wait(3) else Wait(2500) end
    end
end)

function MenuExtra()
    local MenuExtra = {}
    local liveryItems = {}
    local ColorLists = {}
    local liveryCount = 0
    local LiveryIndex = 1
    local ColorIndex = 1


    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    props = QBCore.Functions.GetVehicleProperties(veh)
    liveryCount = GetVehicleLiveryCount(veh)
    for i = 1, #Config.Color do table.insert(ColorLists, Config.Color[i].name) end
    for i = 1, liveryCount do table.insert(liveryItems, "Livery " .. i .. " / "..liveryCount) end

    MenuExtra.Menu = RageUI.CreateMenu("MENU EXTRA", "Que souaitez-vous faire ?")
    MenuExtra.Extra = RageUI.CreateSubMenu(MenuExtra.Menu, "Extra", "Ajouter ou retirer des extras")
    MenuExtra.Livery = RageUI.CreateSubMenu(MenuExtra.Menu, "Livery", "Changer la livery")
    MenuExtra.Color = RageUI.CreateSubMenu(MenuExtra.Menu, "Couleurs", "Changer la couleur de votre véhicule")

    MenuExtra.Menu.Closable = true
    MenuExtra.Menu.Closed = function()
        RageUI.Visible(MenuExtra.Menu, false)
        ExtraMenu = false
    end
    
    if ExtraMenu then ExtraMenu = false else ExtraMenu = true
        RageUI.Visible(MenuExtra.Menu, true)
        CreateThread(function()
            while (ExtraMenu) do
                Wait(2)
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

                RageUI.IsVisible(MenuExtra.Menu, function()
                    RageUI.Button("Ajouter/Retirer des extras", nil, {RightLabel = "→→→"}, true, {}, MenuExtra.Extra)
                    
                    if liveryCount > 1 then
                        RageUI.List("Changer la livery", liveryItems, LiveryIndex, nil, {}, true, {
                            onListChange = function(Index)
                                LiveryIndex = Index
                                SetVehicleLivery(vehicle, Index - 1)
                            end
                        })
                    end

                    RageUI.List("Changer la couleur", ColorLists, ColorIndex, nil, {}, true, {
                        onListChange = function(Index)
                            ColorIndex = Index
                            SetVehicleColours(vehicle, Config.Color[ColorIndex].color, Config.Color[ColorIndex].color2)
                        end
                    })

                end)   

                RageUI.IsVisible(MenuExtra.Extra, function()
                    if vehicle and vehicle ~= 0 then
                        local numExtras = 12
                        for i = 1, numExtras do
                            if DoesExtraExist(vehicle, i) then
                                local isExtraOn = IsVehicleExtraTurnedOn(vehicle, i)
                                RageUI.Checkbox( "Extra " .. i, nil, isExtraOn, {}, {
                                    onChecked = function() SetVehicleExtra(vehicle, i, 0) end,
                                    onUnChecked = function() SetVehicleExtra(vehicle, i, 1) end
                                })
                            end
                        end
                    end
                end)                                  

            end        
        end)
    end
end