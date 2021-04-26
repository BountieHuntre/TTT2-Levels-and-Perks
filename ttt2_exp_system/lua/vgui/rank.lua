include("menu.lua")

local materialIcon = Material("vgui/ttt/vskin/helpscreen/addons")

perk_menu.populate["rank"] = function(perkData, id)
    local thing = perkData:RegisterSubMenu(id)

    thing:SetTitle("Rank")
    thing:SetDescription("")
    thing:SetIcon(materialIcon)
end