local maxLevel = 99

local dataTypes = {
    ["playerLevel"] = 1,
    ["playerExp"] = 0,
    ["playerKills"] = 0
}

PLAYER = FindMetaTable("Player")

local function AutoComplete(cmd, stringargs)
    stringargs = string.Trim(stringargs)
    stringargs = string.lower(stringargs)

    local tbl = {}

    for k, v in ipairs(player.GetAll()) do
        local nick = v:Nick()
        if string.find(string.lower(nick), stringargs) then
            nick = "\"" .. nick .. "\""
            nick = cmd .. " " .. nick

            table.insert(tbl, nick)
        end
    end

    return tbl
end

local function setValues(ply, ...)
    local arg = { ... }

    if #arg ~= 0 then
        local s = 2

        for i = 1, #arg, 2 do
            if arg[i] ~= nil and arg[s] ~= nil then
                ply:SetPData(arg[i], arg[s])
                ply:SetNWInt(arg[i], arg[s])

                print("Set " .. ply:Nick() .. "'s " .. arg[i] .. " to " .. arg[s] .. ".")

                s = s + 2
            end
        end
    else
        for k, v in pairs(dataTypes) do
            if ply:GetPData(k) == nil and ply:GetNWInt(k) == nil or ply:GetNWInt(k) == 0 then
                ply:SetPData(k, v)
                ply:SetNWInt(k, v)
            else
                ply:SetPData(k, ply:GetNWInt(k))
                ply:SetNWInt(k, ply:GetPData(k))
            end
        end
    end
end

local function checkForLevel(ply)
    local etl = (ply:GetNWInt("playerLevel") * 100) * (ply:GetNWInt("playerLevel") * 1.2)
    local cExp = ply:GetNWInt("playerExp")
    local cLvl = ply:GetNWInt("playerLevel")

    if tonumber(cExp) >= tonumber(etl) then
        cExp = cExp - etl

        setValues(ply)
        setValues(ply, "playerExp", cExp, "playerLevel", math.Clamp(cLvl + 1, 0, maxLevel))
    end
end

local function deleteData(ply)
    for k, v in pairs(dataTypes) do
        setValues(ply, k, v)
    end
end

local function reset(ply, cmd, args)
    if ply:IsAdmin() or ply:IsSuperAdmin() or ply:IsUserGroup("owner") then
        local target = NULL

        for k, v in pairs(player.GetAll()) do
            if (string.find(string.lower(v:GetName()), string.lower(args[1])) ~= nil) then
                target = v

                break
            end
        end
        if IsPlayer(target) then
            deleteData(ply)
        else
            print("Couldn't findtarget with partial name: ", args[1])
        end
    end
end
concommand.Add("cmd_reset_player", reset, AutoComplete)

function resetall(ply)
    if ply:IsAdmin() or ply:IsSuperAdmin() or ply:IsUserGroup("owner") then
        for k, v in pairs(player.GetAll()) do
            deleteData(v)
        end
    end
end
concommand.Add("cmd_reset_all", resetall)

-- exp system hook section

hook.Add("PlayerInitialSpawn", "func_exp_setup", function(ply)
    setValues(ply)
end)

hook.Add("PlayerSpawn", "func_exp_refresh", function(ply)
    setValues(ply)
end)

hook.Add("PlayerDeath", "func_exp_death", function(vic, infl, att)
    if IsPlayer(vic) and IsPlayer(att) and att ~= vic and tonumber(att:GetNWInt("playerLevel")) < maxLevel then
        setValues(att, "playerExp", math.ceil(att:GetNWInt("playerExp") + (100 * vic:GetNWInt("playerLevel") * 0.825)), "playerKills", att:GetNWInt("playerKills") + 1)

        checkForLevel(att)
    end
end)

hook.Add("PlayerDisconnected", "func_exp_discon", function(ply)
    setValues(ply)

    print("Saved " .. ply:Nick() .. "'s data.")
end)

hook.Add("Shutdown", "func_exp_shutdown", function()
    for k, v in pairs(player.GetAll()) do
        setValues(v)

        print("Saved " .. v:Nick() .. "'s data.")
    end
end)



-- perk menu section
/*
hook.Add("ShowSpare1", "hook_perk_menu", function(ply)
    ply:ConCommand("n_perk_menu")
end)
*/