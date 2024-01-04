ESX = exports["es_extended"]:getSharedObject()

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

-- print(Config.MenuExtra['Translate'][Config.MenuExtra.Language].CUSTOMIZATION)

---------------------------------------------------------------
local PoliceOpenExtra = false
RMenu.Add('PoliceOpenExtra', 'menu', RageUI.CreateMenu("~s~SAPD - Customization", Config.MenuExtra['Translate'][Config.MenuExtra.Language].CUSTOMIZATION ))
RMenu.Add('PoliceOpenExtra', Config.MenuExtra['Translate'][Config.MenuExtra.Language].EXTRAS, RageUI.CreateSubMenu(RMenu:Get('PoliceOpenExtra', 'menu'), "~s~SAPD - EXTRAS", Config.MenuExtra['Translate'][Config.MenuExtra.Language].PLACE))
RMenu:Get('PoliceOpenExtra', Config.MenuExtra['Translate'][Config.MenuExtra.Language].EXTRAS):SetRectangleBanner(106, 176, 105, 255)
RMenu.Add('PoliceOpenExtra', Config.MenuExtra['Translate'][Config.MenuExtra.Language].REMOVEEXTRAS, RageUI.CreateSubMenu(RMenu:Get('PoliceOpenExtra', 'menu'), "~s~SAPD - EXTRAS", Config.MenuExtra['Translate'][Config.MenuExtra.Language].REMOVE))
RMenu:Get('PoliceOpenExtra', Config.MenuExtra['Translate'][Config.MenuExtra.Language].REMOVEEXTRAS):SetRectangleBanner(197, 97, 97, 255)
RMenu.Add('PoliceOpenExtra', Config.MenuExtra['Translate'][Config.MenuExtra.Language].OTHERMENU, RageUI.CreateSubMenu(RMenu:Get('PoliceOpenExtra', 'menu'), "~s~SAPD - OTHERS MENU", Config.MenuExtra['Translate'][Config.MenuExtra.Language].OTHERS))
RMenu:Get('PoliceOpenExtra', Config.MenuExtra['Translate'][Config.MenuExtra.Language].OTHERMENU):SetRectangleBanner(204, 210, 104, 255)
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
	Config.MenuExtra['Translate'][Config.MenuExtra.Language].COLORS[1],
	Config.MenuExtra['Translate'][Config.MenuExtra.Language].COLORS[2],
	Config.MenuExtra['Translate'][Config.MenuExtra.Language].COLORS[3],
	Config.MenuExtra['Translate'][Config.MenuExtra.Language].COLORS[4],
	Config.MenuExtra['Translate'][Config.MenuExtra.Language].COLORS[5],
	Config.MenuExtra['Translate'][Config.MenuExtra.Language].COLORS[6],
	Config.MenuExtra['Translate'][Config.MenuExtra.Language].COLORS[7],
	Config.MenuExtra['Translate'][Config.MenuExtra.Language].COLORS[8],
	
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
					ESX.ShowNotification(Config.MenuExtra['Translate'][Config.MenuExtra.Language].NO_VEHICLE)
                break
                elseif #(GetEntityCoords(PlayerPedId()) - Config.MenuExtra['Menu'].CoordsMenu) >= 5.0 then -- Modify this position if you change the menu item
					RageUI.CloseAll()
					ESX.ShowNotification(Config.MenuExtra['Translate'][Config.MenuExtra.Language].TOO_FAR)
                break
				end

                RageUI.IsVisible(RMenu:Get('PoliceOpenExtra', 'menu'), true, true, true, function()
                    RageUI.ButtonWithStyle(Config.MenuExtra['Translate'][Config.MenuExtra.Language].PLACE_EXTRAS, nil, {RightLabel = "→→"}, true ,function(_,_,s)
                    end, RMenu:Get('PoliceOpenExtra', Config.MenuExtra['Translate'][Config.MenuExtra.Language].EXTRAS))

					RageUI.ButtonWithStyle(Config.MenuExtra['Translate'][Config.MenuExtra.Language].REMOVE_EXTRAS, nil, {RightLabel = "→→"}, true ,function(_,_,s)
                    end, RMenu:Get('PoliceOpenExtra', Config.MenuExtra['Translate'][Config.MenuExtra.Language].REMOVEEXTRAS))
					
					RageUI.ButtonWithStyle(Config.MenuExtra['Translate'][Config.MenuExtra.Language].OTHER, nil, {RightLabel = "→→"}, true ,function(_,_,s)
                    end, RMenu:Get('PoliceOpenExtra', Config.MenuExtra['Translate'][Config.MenuExtra.Language].OTHERMENU))
                end)

                RageUI.IsVisible(RMenu:Get('PoliceOpenExtra', Config.MenuExtra['Translate'][Config.MenuExtra.Language].OTHERMENU), true, true, true, function()

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

					RageUI.List(Config.MenuExtra['Translate'][Config.MenuExtra.Language].COLORNAME, arraycar, arrayIndexcar, nil, {}, true, function(Hovered, Active, Selected, i) arrayIndexcar = i
						if (Selected) then
							if couleur[arrayIndexcar] then
								SetVehicleColours(VPed, couleur[arrayIndexcar].color, couleur[arrayIndexcar].color2)
							end
						end
					end)

					RageUI.ButtonWithStyle(Config.MenuExtra['Translate'][Config.MenuExtra.Language].WINDOW, nil, {RightLabel = "→→"}, true, function(_,_,s)
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

                RageUI.IsVisible(RMenu:Get('PoliceOpenExtra', Config.MenuExtra['Translate'][Config.MenuExtra.Language].EXTRAS), true, true, true, function()
				
					RageUI.ButtonWithStyle(Config.MenuExtra['Translate'][Config.MenuExtra.Language].PUT_ALL_EXTRAS, nil, {RightLabel = "→→"}, true ,function(_,_,s)
						if s then 
							local Vengine = GetVehicleEngineHealth(VPed)/10
							local Vengine2 = math.floor(Vengine)

							if Vengine2 >= 99.0 then 

                                ESX.ShowNotification(Config.MenuExtra['Translate'][Config.MenuExtra.Language].EXTRAS_CONFIRM)
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
								ESX.ShowNotification(Config.MenuExtra['Translate'][Config.MenuExtra.Language].TOO_DAMAGED)
							end
						end
					end)

					RageUI.Separator(Config.MenuExtra['Translate'][Config.MenuExtra.Language].EXTRA_MANAGE)

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
									ESX.ShowNotification(Config.MenuExtra['Translate'][Config.MenuExtra.Language].EXTRA_NUMBER..number)
									Citizen.SetTimeout(500, function() TimeoutExtra = false end)

								else 
									ESX.ShowNotification(Config.MenuExtra['Translate'][Config.MenuExtra.Language].TOO_DAMAGED)
								end
                            end
                        end)
                    end

                end)

				RageUI.IsVisible(RMenu:Get('PoliceOpenExtra', Config.MenuExtra['Translate'][Config.MenuExtra.Language].REMOVEEXTRAS), true, true, true, function()

					RageUI.ButtonWithStyle(Config.MenuExtra['Translate'][Config.MenuExtra.Language].REMOVEALL, nil, {RightLabel = "→→"}, true ,function(_,_,s)
						if s then 
							local Vengine = GetVehicleEngineHealth(VPed)/10
							local Vengine2 = math.floor(Vengine)

							if Vengine2 >= 99.0 then 

                                ESX.ShowNotification(Config.MenuExtra['Translate'][Config.MenuExtra.Language].REMOVE_CONFIRM)
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
								ESX.ShowNotification(Config.MenuExtra['Translate'][Config.MenuExtra.Language].TOO_DAMAGED)
							end
						end
					end)

					RageUI.Separator(Config.MenuExtra['Translate'][Config.MenuExtra.Language].EXTRA_MANAGE)

					for i = startIndex, GetNumVehicleModData(VPed, 'extras'), 1 do
						RageUI.ButtonWithStyle("Extra n°"..(i + 1).."", nil, {RightLabel = "→→"}, not TimeoutExtra ,function(_,_,s)
							if s then
								local Vengine = GetVehicleEngineHealth(VPed)/10
								local Vengine2 = math.floor(Vengine)
	
								if Vengine2 >= 99.0 then 

									TimeoutExtra = true
									number = (i + 1)
									SetVehicleModData(VPed, 'extras', {id = number, enable = 1})
									ESX.ShowNotification(Config.MenuExtra['Translate'][Config.MenuExtra.Language].EXTRA_NUMBER..number)
									Citizen.SetTimeout(500, function() TimeoutExtra = false end)
								else 
									ESX.ShowNotification(Config.MenuExtra['Translate'][Config.MenuExtra.Language].TOO_DAMAGED)
								end
							end
						end)
					end

				end)

            end 
        end)
    end 
end


CreateThread(function()
    while true do 
        Wait(4)
        local CoordsP = GetEntityCoords(PlayerPedId())
        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.MenuExtra.JobName then
            if IsPedInAnyVehicle(PlayerPedId(), false) ~= false then  
                if #(CoordsP - Config.MenuExtra['Menu'].CoordsMenu) <= Config.MenuExtra['Menu'].Distance then
                    DrawText3Ds(Config.MenuExtra['Menu'].CoordsMenu.x, Config.MenuExtra['Menu'].CoordsMenu.y, Config.MenuExtra['Menu'].CoordsMenu.z, Config.MenuExtra['Translate'][Config.MenuExtra.Language].Text3D)
                    DrawMarker(36, Config.MenuExtra['Menu'].CoordsMenu.x, Config.MenuExtra['Menu'].CoordsMenu.y, Config.MenuExtra['Menu'].CoordsMenu.z-0.97, Config.MenuExtra['Menu'].Marker.dirX, Config.MenuExtra['Menu'].Marker.dirY, Config.MenuExtra['Menu'].Marker.dirZ, Config.MenuExtra['Menu'].Marker.rotX, Config.MenuExtra['Menu'].Marker.rotY, Config.MenuExtra['Menu'].Marker.rotZ, Config.MenuExtra['Menu'].Marker.scaleX, Config.MenuExtra['Menu'].Marker.scaleY, Config.MenuExtra['Menu'].Marker.scaleZ, Config.MenuExtra['Menu'].Color.red, Config.MenuExtra['Menu'].Color.green, Config.MenuExtra['Menu'].Color.blue, Config.MenuExtra['Menu'].Color.alpha, false, false, true, false, false, false, false, false)
                    if IsControlJustPressed(0, 38) and #(CoordsP - Config.MenuExtra['Menu'].CoordsMenu) <= 2.0 then 
                        for _,v in pairs(Config.MenuExtra['VehicleList']) do 
                            if string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false)))) == v then -- Use (string.lower) if you have problems with the vehicle name
                                OpenMenuExtra()
                            end
                        end
                    end
                else 
                    Wait(1000)
                end
            else
                Wait(2000)
            end
        else
            Wait(3000)
        end
    end
end)
