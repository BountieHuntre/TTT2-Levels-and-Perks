local function HUD()
    local ply = LocalPlayer()

    local maxLevel = 99

    local etl = (ply:GetNWInt("playerLevel") * 100) * (ply:GetNWInt("playerLevel") * 1.2)

    if !ply:Alive() then return end

    draw.SimpleText("Level: " .. ply:GetNWInt("playerLevel"), "DermaDefault", ScrW() - 12, ScrH() - 38, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
    if tonumber(ply:GetNWInt("playerLevel")) < maxLevel then
        draw.SimpleText("EXP: " .. ply:GetNWInt("playerExp") .. " / " .. etl, "DermaDefault", ScrW() - 12, ScrH() - 24, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT)
    end
end
hook.Add("HUDPaint", "func_exp_hud", HUD)
