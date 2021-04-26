include("menu.lua")

local materialIcon = Material("vgui/ttt/vskin/helpscreen/addons")

perk_menu.populate["character_sheet"] = function(perkData, id)
    local thing = perkData:RegisterSubMenu(id)

    thing:SetTitle("Character Sheet")
    thing:SetDescription("")
    thing:SetIcon(materialIcon)
end