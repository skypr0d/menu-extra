---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 500, Height = 43 },
    Text = { X = 11, Y = 7, Scale = 0.25 },
    LeftBadge = { Y = -2, Width = 40, Height = 40 },
    RightBadge = { X = 375, Y = 0, Width = 40, Height = 40 },
    RightText = { X = 420, Y = 7, Scale = 0.25 },
    SelectedSprite = { Dictionary = "commonmenu", Texture = "gradient_nav", Y = 0, Width = 431, Height = 38 },
}

---ButtonWithStyle
---@param Label string
---@param Description string
---@param Style table
---@param Enabled boolean
---@param Callback function
---@param Submenu table
---@return nil
---@public

local progressValue = 0
local isStarted = false
local canInteract = true
local isThreadCreateded = false
local alpha = 100

function RageUI.Button(Label, Description, Style, Enabled, Action, Submenu)
    Enabled = Enabled and (not isWaitingForServer)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil and CurrentMenu() then
        ---@type number
        local Option = RageUI.Options + 1

        if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
            ---@type boolean
            local Active = CurrentMenu.Index == Option
            
            RageUI.ItemsSafeZone(CurrentMenu)

            local haveLeftBadge = Style.LeftBadge and Style.LeftBadge ~= RageUI.BadgeStyle.None
            local haveRightBadge = (Style.RightBadge and Style.RightBadge ~= RageUI.BadgeStyle.None) or (not Enabled and Style.LockBadge ~= RageUI.BadgeStyle.None)
            local LeftBadgeOffset = haveLeftBadge and 27 or 0
            local RightBadgeOffset = haveRightBadge and 32 or 0

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

            RenderRectangle(CurrentMenu.X + 15, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset - 30, SettingsButton.SelectedSprite.Height - 3, 35, 39, 47, 100) -- Background fond rectangle
            
            if Active and canInteract then
                local rectangle_anim = RenderRectangle(CurrentMenu.X + 15 + progressValue, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset - 300, SettingsButton.SelectedSprite.Height - 3, 74, 75, 77, alpha) 
            end
            
            if Active then 
                RenderRectangle(CurrentMenu.X + 15, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset - 427, SettingsButton.SelectedSprite.Height - 3,  133, 133, 133, 255)
            end

            if Enabled then
                if haveLeftBadge then
                    if (Style.LeftBadge ~= nil) then
                        local LeftBadge = Style.LeftBadge(Active)
                        RenderSprite(LeftBadge.BadgeDictionary or "commonmenu", LeftBadge.BadgeTexture or "", CurrentMenu.X + 17, CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, SettingsButton.LeftBadge.Width, SettingsButton.LeftBadge.Height, 0, LeftBadge.BadgeColour and LeftBadge.BadgeColour.R or 255, LeftBadge.BadgeColour and LeftBadge.BadgeColour.G or 255, LeftBadge.BadgeColour and LeftBadge.BadgeColour.B or 255, LeftBadge.BadgeColour and LeftBadge.BadgeColour.A or 255)
                    end
                end
                if haveRightBadge then
                    if (Style.RightBadge ~= nil) then
                        local RightBadge = Style.RightBadge(Active)
                        RenderSprite(RightBadge.BadgeDictionary or "commonmenu", RightBadge.BadgeTexture or "", CurrentMenu.X + SettingsButton.RightBadge.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightBadge.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, SettingsButton.RightBadge.Width, SettingsButton.RightBadge.Height, 0, RightBadge.BadgeColour and RightBadge.BadgeColour.R or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.G or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.B or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.A or 255)
                    end
                end
                
                if Style.RightLabel then
                    RenderText(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset - 15, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, 0, SettingsButton.RightText.Scale, Active and 255 or 153, Active and 255 or 153, Active and 255 or 153, 255, 2)
                end
                                
                local R_ITEM_BUTTON = not Active and 146 or 255; 
                local G_ITEM_BUTTON = not Active and 151 or 255;
                local B_ITEM_BUTTON = not Active and 158 or 255;

                -- TEXT ICI
                RenderText(not Active and Label or Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset + 15, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, 8, SettingsButton.Text.Scale, R_ITEM_BUTTON, G_ITEM_BUTTON, B_ITEM_BUTTON, 255);
            else
                if haveRightBadge then
                    local RightBadge = RageUI.BadgeStyle.Lock(Active)
                    RenderSprite(RightBadge.BadgeDictionary or "commonmenu", RightBadge.BadgeTexture or "", CurrentMenu.X + SettingsButton.RightBadge.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightBadge.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, SettingsButton.RightBadge.Width, SettingsButton.RightBadge.Height, 0, RightBadge.BadgeColour and RightBadge.BadgeColour.R or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.G or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.B or 255, RightBadge.BadgeColour and RightBadge.BadgeColour.A or 255)
                end

                local R_ITEM_BUTTON = not Active and 104 or 124; 
                local G_ITEM_BUTTON = not Active and 108 or 129;
                local B_ITEM_BUTTON = not Active and 114 or 135;

                -- TEXT ICI
                RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset + 15, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + 25, 8, SettingsButton.Text.Scale, R_ITEM_BUTTON, G_ITEM_BUTTON, B_ITEM_BUTTON, 255);
            end
            RageUI.ItemOffset = RageUI.ItemOffset + SettingsButton.Rectangle.Height
            
            RageUI.ItemsDescription(CurrentMenu, Description, Active);
            if Enabled then
                local Hovered = CurrentMenu.EnableMouse and (CurrentMenu.CursorStyle == 0 or CurrentMenu.CursorStyle == 1) and RageUI.ItemsMouseBounds(CurrentMenu, Active, Option + 1, SettingsButton);
                local Selected = (CurrentMenu.Controls.Select.Active or (Hovered and CurrentMenu.Controls.Click.Active)) and Active
                if (Action.onHovered ~= nil) and Hovered then
                    Action.onHovered();
                end
                if (Action.onActive ~= nil) and Active then
                    Action.onActive();
                end
                if Selected then
                    local Audio = RageUI.Settings.Audio
                    RageUI.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)
                    if (Action.onSelected ~= nil) then
                        Citizen.CreateThread(function()
                            Action.onSelected();
                        end)
                    end
                    if Submenu and Submenu() then
                        RageUI.NextMenu = Submenu
                    end
                end
            end
        end
        RageUI.Options = RageUI.Options + 1
    end
end

function RageUI.ReloadAnimation()
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