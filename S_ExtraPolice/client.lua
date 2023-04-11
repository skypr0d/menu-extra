ESX = exports["es_extended"]:getSharedObject()
TriggerEvent('esx:getActiveLifeObject', function(obj) ESX = obj end) -- Edit your ESX Trigger

----------------------------------------------------------------

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

function DrawText3Ds(x, y, z, text)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
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

---------------------------------------------------------------
local PoliceOpenExtra = false
RMenu.Add('PoliceOpenExtra', 'menu', RageUI.CreateMenu("~s~SAPD - Customization", LANGS[configLang].CUSTOMIZATION ))
RMenu.Add('PoliceOpenExtra', LANGS[configLang].EXTRAS, RageUI.CreateSubMenu(RMenu:Get('PoliceOpenExtra', 'menu'), "~s~SAPD - EXTRAS", LANGS[configLang].PLACE))
RMenu:Get('PoliceOpenExtra', LANGS[configLang].EXTRAS):SetRectangleBanner(106, 176, 105, 255)
RMenu.Add('PoliceOpenExtra', LANGS[configLang].REMOVEEXTRAS, RageUI.CreateSubMenu(RMenu:Get('PoliceOpenExtra', 'menu'), "~s~SAPD - EXTRAS", LANGS[configLang].REMOVE))
RMenu:Get('PoliceOpenExtra', LANGS[configLang].REMOVEEXTRAS):SetRectangleBanner(197, 97, 97, 255)
RMenu.Add('PoliceOpenExtra', LANGS[configLang].OTHERMENU, RageUI.CreateSubMenu(RMenu:Get('PoliceOpenExtra', 'menu'), "~s~SAPD - OTHERS MENU", LANGS[configLang].OTHERS))
RMenu:Get('PoliceOpenExtra', LANGS[configLang].OTHERMENU):SetRectangleBanner(204, 210, 104, 255)
RMenu:Get('PoliceOpenExtra', 'menu').Closed = function()
    PoliceOpenExtra = false
end


function SetVehicleModData(vehicle, modType, data)
	if (modType == 'extras') then
		local tempList = {}
		for id = 0, 25, 1 do
			if (DoesExtraExist(vehicle, id)) then
				table.insert(tempList, id)
			end
		end
		
		if (DoesExtraExist(vehicle, tempList[data.id])) then
			SetVehicleExtra(vehicle, tempList[data.id], data.enable)
		end
	end
end


function GetVehicleCurrentMod(vehicle, modType, data)
	if (modType == 'extras') then
		local tempList = {}
		for id = 0, 25, 1 do
			if (DoesExtraExist(vehicle, id)) then
				table.insert(tempList, id)
			end
		end
		
		if (tempList[data] ~= nil and IsVehicleExtraTurnedOn(vehicle, tempList[data])) then
			return 0
		end
	end
	return -1
end


function GetNumVehicleModData(vehicle, modType)
	SetVehicleModKit(vehicle, 0)

	if (modType == 'extras') then
		local tempCount = -1
		for id = 0, 25, 1 do
			if (DoesExtraExist(vehicle, id)) then
				tempCount = tempCount + 1
			end
		end
		return tempCount
	end

	return -1
end

local arraycar = {
    -- "Noir", --1
    -- "Rouge",--2
    -- "Vert",--3
    -- "Blanc",--4
    -- "Jaune",--5
    -- "Violet",--6
    -- "Orange",--7
    -- "Bleu",--8
	LANGS[configLang].COLORS[1],
	LANGS[configLang].COLORS[2],
	LANGS[configLang].COLORS[3],
	LANGS[configLang].COLORS[4],
	LANGS[configLang].COLORS[5],
	LANGS[configLang].COLORS[6],
	LANGS[configLang].COLORS[7],
	LANGS[configLang].COLORS[8],
	
}

local couleur = {
    [1] = {color = 0, color2 = 0},
    [2] = {color = 27, color2 = 27},
    [3] = {color = 50, color2 = 50},
    [4] = {color = 112, color2 = 112},
    [5] = {color = 88, color2 = 88},
    [6] = {color = 71, color2 = 71},
    [7] = {color = 38, color2 = 38},
    [8] = {color = 64, color2 = 64},
}

local arrayIndexcar = 1
local startIndex = 0
local livery = 0
local Window = 0

function OpenMenuExtra()
    if PoliceOpenExtra then PoliceOpenExtra = false else PoliceOpenExtra = true
        RageUI.Visible(RMenu:Get('PoliceOpenExtra', 'menu'), true)
		Citizen.CreateThread(function()
            while PoliceOpenExtra do Wait(0)
				local VPed = GetVehiclePedIsIn(PlayerPedId(), false)

				if IsPedInAnyVehicle(PlayerPedId(), false) == false then 
					RageUI.CloseAll()
					--exports['ActiveLife']:Alert("", "Tu n'est plus dans un véhicule", 10000, 'error')
					ESX.ShowNotification(LANGS[configLang].NO_VEHICLE)
					break
				elseif #(GetEntityCoords(PlayerPedId()) - Config.ModificationLocation) >= 5.0 then -- Modify this position if you change the menu item
					RageUI.CloseAll()
					--exports['ActiveLife']:Alert("", "Tu es trop loin du point !", 10000, 'error')
					ESX.ShowNotification(LANGS[configLang].TOO_FAR)
					break
				end

                RageUI.IsVisible(RMenu:Get('PoliceOpenExtra', 'menu'), true, true, true, function()
                    RageUI.ButtonWithStyle(LANGS[configLang].PLACE_EXTRAS, nil, {RightLabel = "→→"}, true ,function(_,_,s)
                    end, RMenu:Get('PoliceOpenExtra', LANGS[configLang].EXTRAS))

					RageUI.ButtonWithStyle(LANGS[configLang].REMOVE_EXTRAS, nil, {RightLabel = "→→"}, true ,function(_,_,s)
                    end, RMenu:Get('PoliceOpenExtra', LANGS[configLang].REMOVEEXTRAS))
					
					RageUI.ButtonWithStyle(LANGS[configLang].OTHER, nil, {RightLabel = "→→"}, true ,function(_,_,s)
                    end, RMenu:Get('PoliceOpenExtra', LANGS[configLang].OTHERMENU))
                end)

                RageUI.IsVisible(RMenu:Get('PoliceOpenExtra', LANGS[configLang].OTHERMENU), true, true, true, function()

					RageUI.ButtonWithStyle('Livery', nil, {RightLabel = "→→"}, true, function(_,_,s)
						if s then
							local countlivery = GetVehicleLiveryCount(VPed)
							SetVehicleLivery(VPed, livery)
							livery = livery + 1
							if livery >= countlivery then
								livery = 0
							end
						end
					end)

					RageUI.List(LANGS[configLang].COLORNAME, arraycar, arrayIndexcar, nil, {}, true, function(Hovered, Active, Selected, i) arrayIndexcar = i
						if (Selected) then
							if couleur[arrayIndexcar] then
								SetVehicleColours(VPed, couleur[arrayIndexcar].color, couleur[arrayIndexcar].color2)
							end
						end
					end)

					RageUI.ButtonWithStyle(LANGS[configLang].WINDOW, nil, {RightLabel = "→→"}, true, function(_,_,s)
						if s then
							local CountWindow = GetNumVehicleWindowTints(VPed)
							SetVehicleWindowTint(VPed, Window)
							Window = Window + 1
							if Window >= CountWindow then
								Window = 0
							end
						end
					end)


				end)

                RageUI.IsVisible(RMenu:Get('PoliceOpenExtra', LANGS[configLang].EXTRAS), true, true, true, function()
				
					RageUI.ButtonWithStyle(LANGS[configLang].PUT_ALL_EXTRAS, nil, {RightLabel = "→→"}, true ,function(_,_,s)
						if s then 
							local Vengine = GetVehicleEngineHealth(VPed)/10
							local Vengine2 = math.floor(Vengine)

							if Vengine2 >= 99.0 then 

								--exports['ActiveLife']:Alert("", "Vous avez mis tout les extras de votre véhicule", 5000, 'success')
								ESX.ShowNotification(LANGS[configLang].EXTRAS_CONFIRM)
								for i = startIndex, GetNumVehicleModData(VPed, 'extras'), 1 do
									liste = 0
									while true do 
										liste = liste + 1
										SetVehicleModData(VPed, 'extras', {id = liste, enable = 0})
										if liste == 10 then 
											liste = 0 
											break 
										end
									end 
								end
							else 
								--exports['ActiveLife']:Alert("", "Véhicule trop abimé", 5000, 'error')
								ESX.ShowNotification(LANGS[configLang].TOO_DAMAGED)
							end
						end
					end)

					RageUI.Separator(LANGS[configLang].EXTRA_MANAGE)

                    for i = startIndex, GetNumVehicleModData(VPed, 'extras'), 1 do
                        RageUI.ButtonWithStyle("Extra n°"..(i + 1).."", nil, {RightLabel = "→→"}, not TimeoutExtra ,function(_,_,s)
                            if s then
								local Vengine = GetVehicleEngineHealth(VPed)/10
								local Vengine2 = math.floor(Vengine)
	
								if Vengine2 >= 99.0 then 

									TimeoutExtra = true
									number = (i + 1)
									mis = true
									SetVehicleModData(VPed, 'extras', {id = number, enable = 0})
									--exports['ActiveLife']:Alert("", "Vous avez mis l'extra n°"..number.." sur votre véhicule.", 1000, 'success')
									ESX.ShowNotification(LANGS[configLang].EXTRA_NUMBER..number)
									Citizen.SetTimeout(500, function() TimeoutExtra = false end)

								else 
									--exports['ActiveLife']:Alert("", "Véhicule trop abimé", 5000, 'error')
									ESX.ShowNotification(LANGS[configLang].TOO_DAMAGED)
								end
                            end
                        end)
                    end

                end)

				RageUI.IsVisible(RMenu:Get('PoliceOpenExtra', LANGS[configLang].REMOVEEXTRAS), true, true, true, function()

					RageUI.ButtonWithStyle(LANGS[configLang].REMOVEALL, nil, {RightLabel = "→→"}, true ,function(_,_,s)
						if s then 
							local Vengine = GetVehicleEngineHealth(VPed)/10
							local Vengine2 = math.floor(Vengine)

							if Vengine2 >= 99.0 then 

								--exports['ActiveLife']:Alert("", "Vous avez retiré tout les extras de votre véhicule", 5000, 'nosuccess')   
								 ESX.ShowNotification(LANGS[configLang].REMOVE_CONFIRM)
								for i = startIndex, GetNumVehicleModData(VPed, 'extras'), 1 do
									liste = 0
									while true do 
										liste = liste + 1
										SetVehicleModData(VPed, 'extras', {id = liste, enable = 1})
										if liste == 10 then 
											liste = 0 
											break 
										end
									end 
								end
							else 
								--exports['ActiveLife']:Alert("", "Véhicule trop abimé", 5000, 'error')   
								ESX.ShowNotification(LANGS[configLang].TOO_DAMAGED)
							end
						end
					end)

					RageUI.Separator(LANGS[configLang].EXTRA_MANAGE)

					for i = startIndex, GetNumVehicleModData(VPed, 'extras'), 1 do
						RageUI.ButtonWithStyle("Extra n°"..(i + 1).."", nil, {RightLabel = "→→"}, not TimeoutExtra ,function(_,_,s)
							if s then
								local Vengine = GetVehicleEngineHealth(VPed)/10
								local Vengine2 = math.floor(Vengine)
	
								if Vengine2 >= 99.0 then 

									TimeoutExtra = true
									number = (i + 1)
									SetVehicleModData(VPed, 'extras', {id = number, enable = 1})
									--exports['ActiveLife']:Alert("", "Vous avez mis l'extra n°"..number.." sur votre véhicule.", 1000, 'nosuccess')
									ESX.ShowNotification(LANGS[configLang].EXTRA_NUMBER..number)
									Citizen.SetTimeout(500, function() TimeoutExtra = false end)
								else 
									--exports['ActiveLife']:Alert("", "Véhicule trop abimé", 5000, 'error')
									ESX.ShowNotification(LANGS[configLang].TOO_DAMAGED)
								end
							end
						end)
					end

				end)

            end 
        end)
    end 
end
                            
--[[local vehicle = { -- Whitelist vehicle lists
	'18charger',
	'cvpi',
	'16charger',
	'PBUFFALO4',
	'16exp',
	'police',
	'police2',
	'police3',
	'police4',
	'POLICE4',
	'18chargerw'
} ]]

Citizen.CreateThread(function()
    while true do 
        Wait(4)
        local CoordsP = GetEntityCoords(PlayerPedId())
			if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.JobName then
				if IsPedInAnyVehicle(PlayerPedId(), false) ~= false then  
					for k,v in pairs(ConfigModifVehicleSAPD) do
						if #(CoordsP - v.Position) <= v.Distance then
							DrawText3Ds(v.Position.x, v.Position.y, v.Position.z, ""..v.Text3D.."")
							DrawMarker(36, v.Position.x, v.Position.y, v.Position.z-0.97, v.Marker.dirX, v.Marker.dirY, v.Marker.dirZ, v.Marker.rotX, v.Marker.rotY, v.Marker.rotZ, v.Marker.scaleX, v.Marker.scaleY, v.Marker.scaleZ, v.Color.red, v.Color.green, v.Color.blue, v.Color.alpha, false, false, true, false, false, false, false, false)
							if IsControlJustPressed(0, 38) and #(CoordsP - v.Position) <= 2.0 then 
-- 								print(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))))
								for _,v in pairs(configVehicleList) do 
									if GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))) == v then -- Use (string.lower) if you have problems with the vehicle name
										OpenMenuExtra()
									end
								end
							end
						else 
							Wait(1000)
						end
					end
				else
					Wait(2000)
				end
			else
				Wait(3000)
			end
    end
end)
