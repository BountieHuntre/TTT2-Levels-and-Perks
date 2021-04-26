include("menu.lua")

local materialIcon = Material("vgui/ttt/vskin/helpscreen/addons")

perk_menu.populate["perks"] = function(perkData, id)
    local thing = perkData:RegisterSubMenu(id)

    thing:SetTitle("Perk")
    thing:SetDescription("")
    thing:SetIcon(materialIcon)
end