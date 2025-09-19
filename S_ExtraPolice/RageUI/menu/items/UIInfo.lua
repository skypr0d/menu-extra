function RageUI.Info(Title, RightText, LeftText)
    local LineCount = #RightText >= #LeftText and #RightText or #LeftText
    if Title ~= nil then
        RenderText("~h~" .. Title .. "~s~", 330 + 20 + 100, 7, 0, 0.30, 255, 255, 255, 255, 0)
    end
    if RightText ~= nil then
        RenderText(table.concat(RightText, "\n"), 330 + 20 + 100, Title ~= nil and 37 or 7, 0, 0.25, 255, 255, 255, 255, 0)
    end
    if LeftText ~= nil then
        RenderText(table.concat(LeftText, "\n"), 330 + 432 + 100, Title ~= nil and 37 or 7, 0, 0.25, 255, 255, 255, 255, 2)
    end

    RenderRectangle(330 + 10 + 100, 0, 432, Title ~= nil and 50 + (LineCount * 20) or ((LineCount + 1) * 20), 20, 24, 28, 255)
end

--RageUI.Info("Titre", {"Sous titre 1", "Sous titre 2", "Sous titre 3","Sous titre 4"}, {"Sous titre droite 1", "Sous titre droite 2", "Sous titre droite 3","Sous titre droite 4" })