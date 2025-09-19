local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = 43 },
    Text = { X = 23, Y = 5, Scale = 0.25 },
    LeftBadge = { Y = -2, Width = 40, Height = 40 },
    RightBadge = { X = 385, Y = -2, Width = 40, Height = 40 },
    RightText = { X = 405, Y = 4, Scale = 0.25 },
    SelectedSprite = { Dictionary = "commonmenu.ytd", Texture = "gradient_nav", Y = 0, Width = 431, Height = 38 },
}

---@type table
local SettingsList = {
    LeftArrow = { Dictionary = "commonmenu.ytd", Texture = "arrowleft", X = 378, Y = 3, Width = 30, Height = 30 },
    RightArrow = { Dictionary = "commonmenu.ytd", Texture = "arrowright", X = 400, Y = 3, Width = 30, Height = 30 },
    Text = { X = 400, Y = 3, Scale = 0.30 },
}

local progressValue = 0
local isStarted = false
local canInteract = true
local isThreadCreateded = false
local alpha = 100

function RageUI.List(Label, Items, Index, Description, Style, Enabled, Actions, Submenu, IndexColor)
    ---@type table
    local CurrentMenu = RageUI.CurrentMenu;
    if CurrentMenu ~= nil then
        if CurrentMenu() then

            ---@type number
            local Option = RageUI.Options + 1

            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then

                ---@type number
                local Selected = CurrentMenu.Index == Option

                ---@type boolean
                local LeftArrowHovered, RightArrowHovered = false, false

                RageUI.ItemsSafeZone(CurrentMenu)

                local Hovered = false;
                local LeftBadgeOffset = ((Style.LeftBadge == RageUI.BadgeStyle.None or Style.LeftBadge == nil) and 0 or 27)
                local RightBadgeOffset = ((Style.RightBadge == RageUI.BadgeStyle.None or Style.RightBadge == nil) and 0 or 32)
                local RightOffset = 0

                if not isThreadCreateded then
                    isThreadCreateded = true
                    Citizen.CreateThread(function() 
                        while true do
                            if progressValue <= 5 then 
                                progressValue = progressValue + 2
                            else
                                progressValue = progressValue + 7
                            end
                            
                            alpha = alpha - 3,5
    
                            if progressValue >= 300 then 
                                progressValue = 0
                                alpha = 100
                                canInteract = false
                            end
    
                            if not RageUI.CurrentMenu then 
                                isThreadCreateded = false
                                canInteract = true
                                return
                            end
    
                            Wait(10)
                        end
                    end)
                end

                RenderRectangle(CurrentMenu.X + 15, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset - 30, SettingsButton.SelectedSprite.Height - 3, 35, 39, 47, 100)

                if Selected and canInteract then
                    local rectangle_anim = RenderRectangle(CurrentMenu.X + 15 + progressValue, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset - 300, SettingsButton.SelectedSprite.Height - 3, 74, 75, 77, alpha) 
                end

                if Selected then 
                    RenderRectangle(CurrentMenu.X + 15, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset - 427, SettingsButton.SelectedSprite.Height - 3, 133, 133, 133, 255)
                end

                ---@type boolean
                local ListText = (type(Items[Index]) == "table") and string.format("← %s →", Items[Index].Name) or string.format("← %s%s~s~ →", (IndexColor ~= nil and IndexColor or "~s~"), Items[Index]) or "NIL"
                if Enabled == true or Enabled == nil then
                    if Selected then
                        if Style.RightLabel ~= nil and Style.RightLabel ~= "" then
                            RenderText(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, 8, SettingsButton.RightText.Scale, 0, 0, 0, 0, 2)
                            RightOffset = MeasureStringWidth(Style.RightLabel, 0, 0.35)
                        end
                    else
                        if Style.RightLabel ~= nil and Style.RightLabel ~= "" then
                            RightOffset = MeasureStringWidth(Style.RightLabel, 0, 0.35)
                            RenderText(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, 8, SettingsButton.RightText.Scale, 0, 0, 0, 0, 2)
                        end
                    end
                end
                RightOffset = RightBadgeOffset * 1.3 + RightOffset
                if Enabled == true or Enabled == nil then
                    if Selected then
                        RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, 8, SettingsButton.Text.Scale, 255, 255, 255, 255)
                        RenderText(ListText, CurrentMenu.X + SettingsList.Text.X + 5 + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + SettingsList.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, 8, SettingsList.Text.Scale, 255, 255, 255, 255, 2)
                    else
                        RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, 8, SettingsButton.Text.Scale, 146, 151, 158, 255)
                        RenderText(ListText, CurrentMenu.X + SettingsList.Text.X + 5 + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + SettingsList.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, 8, SettingsList.Text.Scale, 153, 153, 153, 255, 2)
                    end
                else
                    RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, 8, SettingsButton.Text.Scale, 163, 159, 148, 255)
                    if Selected then
                        RenderText(ListText, CurrentMenu.X + SettingsList.Text.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsList.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, 8, SettingsList.Text.Scale, 163, 159, 148, 255, 2)
                    else
                        RenderText(ListText, CurrentMenu.X + SettingsList.Text.X + 5 + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsList.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, 8, SettingsList.Text.Scale, 163, 159, 148, 255, 2)
                    end
                end

                if type(Style) == "table" then
                    if Style.Enabled == true or Style.Enabled == nil then
                        if type(Style) == 'table' then
                            if Style.LeftBadge ~= nil then
                                if Style.LeftBadge ~= RageUI.BadgeStyle.None then
                                    local BadgeData = Style.LeftBadge(Selected)

                                    RenderSprite("commonmenu.ytd", BadgeData.BadgeTexture or "", CurrentMenu.X, CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, SettingsButton.LeftBadge.Width, SettingsButton.LeftBadge.Height, 0, BadgeData.BadgeColour and BadgeData.BadgeColour.R or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.G or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.B or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.A or 255)
                                end
                            end

                            if Style.RightBadge ~= nil then
                                if Style.RightBadge ~= RageUI.BadgeStyle.None then
                                    local BadgeData = Style.RightBadge(Selected)

                                    RenderSprite("commonmenu.ytd", BadgeData.BadgeTexture or "", CurrentMenu.X + SettingsButton.RightBadge.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightBadge.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, SettingsButton.RightBadge.Width, SettingsButton.RightBadge.Height, 0, BadgeData.BadgeColour and BadgeData.BadgeColour.R or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.G or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.B or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.A or 255)
                                end
                            end
                        end
                    else
                        ---@type table
                        local LeftBadge = RageUI.BadgeStyle.Lock
                        ---@type number
                        if LeftBadge ~= RageUI.BadgeStyle.None and LeftBadge ~= nil then
                            local BadgeData = LeftBadge(Selected)

                            RenderSprite("commonmenu.ytd", BadgeData.BadgeTexture or "", CurrentMenu.X, CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, SettingsButton.LeftBadge.Width, SettingsButton.LeftBadge.Height, 0, BadgeData.BadgeColour.R or 255, BadgeData.BadgeColour.G or 255, BadgeData.BadgeColour.B or 255, BadgeData.BadgeColour.A or 255)
                        end
                    end
                else
                    error("UICheckBox Style is not a `table`")
                end

                LeftArrowHovered = RageUI.IsMouseInBounds(CurrentMenu.X + SettingsList.Text.X + CurrentMenu.WidthOffset - RightOffset + CurrentMenu.SafeZoneSize.X, CurrentMenu.Y + SettingsList.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 2.5  + CurrentMenu.SafeZoneSize.Y , 15, 22.5)
                RightArrowHovered = RageUI.IsMouseInBounds(CurrentMenu.X + SettingsList.Text.X + CurrentMenu.WidthOffset + CurrentMenu.SafeZoneSize.X - RightOffset - MeasureStringWidth(ListText, 0, SettingsList.Text.Scale), CurrentMenu.Y + SettingsList.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 2.5 + CurrentMenu.SafeZoneSize.Y , 15, 22.5)
                RageUI.ItemOffset = RageUI.ItemOffset + SettingsButton.Rectangle.Height

                RageUI.ItemsDescription(CurrentMenu, Description, Selected);
                if Selected and (CurrentMenu.Controls.Left.Active or (CurrentMenu.Controls.Click.Active and LeftArrowHovered)) and not (CurrentMenu.Controls.Right.Active or (CurrentMenu.Controls.Click.Active and RightArrowHovered)) then
                    Index = Index - 1
                    if Index < 1 then Index = 1 end
                    if (Actions.onListChange ~= nil) then
                        Actions.onListChange(Index, Items[Index]);
                    end
                    local Audio = RageUI.Settings.Audio
                    TriggerEvent("InteractSound_CL:PlayOnOne", "selected", 0.2)
                elseif Selected and (CurrentMenu.Controls.Right.Active or (CurrentMenu.Controls.Click.Active and RightArrowHovered)) and not (CurrentMenu.Controls.Left.Active or (CurrentMenu.Controls.Click.Active and LeftArrowHovered)) then
                    Index = Index + 1
                    if Index > #Items then Index = #Items end
                    if (Actions.onListChange ~= nil) then
                        Actions.onListChange(Index, Items[Index]);
                    end
                    local Audio = RageUI.Settings.Audio
                    TriggerEvent("InteractSound_CL:PlayOnOne", "selected", 0.2)
                end

                if Selected and (CurrentMenu.Controls.Select.Active or ((Hovered and CurrentMenu.Controls.Click.Active) and (not LeftArrowHovered and not RightArrowHovered))) then
                    local Audio = RageUI.Settings.Audio
                    TriggerEvent("InteractSound_CL:PlayOnOne", "selected", 0.2)
                    if (Actions.onSelected ~= nil and not isWaitingForServer) then
                        Actions.onSelected(Index, Items[Index]);
                    end

                    if Submenu ~= nil and type(Submenu) == "table" then
                        RageUI.NextMenu = Submenu[Index]
                    end
                elseif Selected then
                    if(Actions.onActive ~= nil) then
                        Actions.onActive()
                    end 
                end
            end

            RageUI.Options = RageUI.Options + 1
        end
    end
end

function RageUI.ReloadAnimationList()
    Citizen.CreateThread(function() 
        while true do
            Wait(100)
            progressValue = 0
            canInteract = true 
            alpha = 100
            break
        end
    end)
end