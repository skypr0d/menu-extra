-- local SettingsSlider = {
--     Background = { Y = 20, Width = 300, Height = 8 }, -- Augmentation de la taille de la barre
--     Slider = { Y = 20, Width = 300, Height = 8 },
-- }

-- function RageUI.CenteredProgressBar(CurrentValue, MaxValue, Style, Enabled, Actions)
--     ---@type table
--     local CurrentMenu = RageUI.CurrentMenu
--     local Audio = RageUI.Settings.Audio

--     if CurrentMenu ~= nil then
--         if CurrentMenu() then
--             ---@type number
--             local Option = RageUI.Options + 1

--             if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
--                 RageUI.ItemsSafeZone(CurrentMenu)

--                 local CenterX = CurrentMenu.X + (CurrentMenu.WidthOffset / 2) - (SettingsSlider.Background.Width - (SettingsSlider.Background.Width * 1.195)) 
--                 -- Dessiner le fond de la barre
--                 if (type(Style.ProgressBackgroundColor) == "table") then
--                     RenderRectangle(
--                         CenterX,
--                         CurrentMenu.Y + SettingsSlider.Background.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset,
--                         SettingsSlider.Background.Width,
--                         SettingsSlider.Background.Height,
--                         Style.ProgressBackgroundColor.R,
--                         Style.ProgressBackgroundColor.G,
--                         Style.ProgressBackgroundColor.B,
--                         Style.ProgressBackgroundColor.A
--                     )
--                 else
--                     error("Style ProgressBackgroundColor is not a table or undefined")
--                 end

--                 -- Dessiner la partie remplie
--                 local ProgressWidth = (SettingsSlider.Slider.Width * CurrentValue) / MaxValue
--                 if (type(Style.ProgressColor) == "table") then
--                     RenderRectangle(
--                         CenterX,
--                         CurrentMenu.Y + SettingsSlider.Slider.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset,
--                         ProgressWidth,
--                         SettingsSlider.Slider.Height,
--                         Style.ProgressColor.R,
--                         Style.ProgressColor.G,
--                         Style.ProgressColor.B,
--                         Style.ProgressColor.A
--                     )
--                 else
--                     error("Style ProgressColor is not a table or undefined")
--                 end

--                 RageUI.ItemOffset = RageUI.ItemOffset + SettingsSlider.Background.Height + 10 -- Espacement

--                 -- Gestion des interactions
--                 if Enabled then
--                     if CurrentMenu.Controls.Left.Active then
--                         CurrentValue = math.max(0, CurrentValue - 1)
--                         if Actions.onSliderChange then Actions.onSliderChange(CurrentValue) end
--                         RageUI.PlaySound(Audio[Audio.Use].LeftRight.audioName, Audio[Audio.Use].LeftRight.audioRef)
--                     elseif CurrentMenu.Controls.Right.Active then
--                         CurrentValue = math.min(MaxValue, CurrentValue + 1)
--                         if Actions.onSliderChange then Actions.onSliderChange(CurrentValue) end
--                         RageUI.PlaySound(Audio[Audio.Use].LeftRight.audioName, Audio[Audio.Use].LeftRight.audioRef)
--                     end

--                     if CurrentMenu.Controls.Select.Active then
--                         if Actions.onSelected then Actions.onSelected(CurrentValue) end
--                         RageUI.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)
--                     end
--                 end
--             end

--             RageUI.Options = RageUI.Options + 1
--         end
--     end
-- end

local SettingsSlider = {
    Background = { Y = 20, Width = 400, Height = 4 }, -- Augmentation de la taille de la barre
    Slider = { Y = 20, Width = 400, Height = 4 },
}

function RageUI.CenteredProgressBarStatic(CurrentValue, MaxValue, Style, AddHeight)
    ---@type table
    local CurrentMenu = RageUI.CurrentMenu
    if AddHeight == nil then AddHeight = 0 end
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            ---@type number
            local Option = RageUI.Options + 1

            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
                RageUI.ItemsSafeZone(CurrentMenu)

                -- Calcul de la position centrale
                local CenterX = CurrentMenu.X + (CurrentMenu.WidthOffset / 2) - (SettingsSlider.Background.Width - (SettingsSlider.Background.Width * 1.195)) 

                -- Dessiner le fond de la barre
                if (type(Style.ProgressBackgroundColor) == "table") then
                    RenderRectangle(
                        CurrentMenu.X + 15,
                        CurrentMenu.Y + RageUI.ItemOffset + (SettingsSlider.Background.Y / 2),
                        SettingsSlider.Background.Width,
                        SettingsSlider.Background.Height,
                        Style.ProgressBackgroundColor.R,
                        Style.ProgressBackgroundColor.G,
                        Style.ProgressBackgroundColor.B,
                        Style.ProgressBackgroundColor.A
                    )
                else
                    error("Style ProgressBackgroundColor is not a table or undefined")
                end

                -- Dessiner la partie remplie
                local ProgressWidth = (SettingsSlider.Slider.Width * CurrentValue) / MaxValue
                if (type(Style.ProgressColor) == "table") then
                    RenderRectangle(
                        CurrentMenu.X + 15,
                        CurrentMenu.Y + RageUI.ItemOffset + (SettingsSlider.Slider.Y / 2),
                        ProgressWidth,
                        SettingsSlider.Slider.Height,
                        Style.ProgressColor.R,
                        Style.ProgressColor.G,
                        Style.ProgressColor.B,
                        Style.ProgressColor.A
                    )
                else
                    error("Style ProgressColor is not a table or undefined")
                end

                -- Mise à jour du décalage visuel pour éviter d'affecter les autres éléments du menu
                RageUI.ItemOffset = RageUI.ItemOffset + SettingsSlider.Background.Height + 10

                -- Gestion pour sauter automatiquement cette option
                if (CurrentMenu.Index == Option) then
                    if (RageUI.LastControl) then
                        CurrentMenu.Index = Option - 1
                        if (CurrentMenu.Index < 1) then
                            CurrentMenu.Index = RageUI.CurrentMenu.Options
                        end
                    else
                        CurrentMenu.Index = Option + 1
                    end
                end
            end

            RageUI.Options = RageUI.Options + 1
        end
    end
end
