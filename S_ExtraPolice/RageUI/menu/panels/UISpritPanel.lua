local TextPanels = {
    Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 42 },
}

function RageUI.RenderSprite(Dictionary, Texture)
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            RenderSprite(Dictionary, Texture, CurrentMenu.X, CurrentMenu.Y + TextPanels.Background.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset + (RageUI.StatisticPanelCount * 42), TextPanels.Background.Width + CurrentMenu.WidthOffset, TextPanels.Background.Height + 200, 0, 0, 255, 255, 255);
            RageUI.StatisticPanelCount = RageUI.StatisticPanelCount + 1
        end
    end
end
