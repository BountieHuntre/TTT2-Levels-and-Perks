local mainMenuOrder = {
    "character_sheet",
    "perks",
    "rank"
}

local function InternalModifyPerkMainMenu(perkData)
    for i = 1, #mainMenuOrder do
        local id = mainMenuOrder[i]

        perk_menu.populate[id](perkData, id)
    end
end

perk_menu = perk_menu or {}

perk_menu.populate = perk_menu.populate or {}
perk_menu.currentMenuId = perk_menu.currentMenuId or nil
perk_menu.menuData = perk_menu.menuData or nil 
perk_menu.menuFrame = perk_menu.menuFrame or nil

perk_menu.padding = 5

local mainWidth, mainHeight = math.Round(ScrW() / 2), math.Round(ScrH() / 5)
local width, height = math.Round(ScrW() / 1.5), math.Round(ScrH() / 1.5)
local cols = 3
local widthMainMenuButton = math.Round((width - 2 * perk_menu.padding * (cols + 1)) / cols)
local heightMainMenuButton = math.Round(mainHeight / 1.37)

local function AddMenuButtons(tbl, parent)
    for i = 1, #tbl do
        local data = tbl[i]

        local settingsButton = parent:Add("DMenuButtonTTT2")
        settingsButton:SetSize(widthMainMenuButton, heightMainMenuButton)
        settingsButton:SetTitle(data.title or data.id)
        settingsButton:SetDescription(data.description or "")
        settingsButton:SetImage(data.iconMat)
    end
end

local MAIN_MENU = "main"

function perk_menu:ShowMainMenu()
    local frame = self.menuFrame

    if IsValid(frame) then
        frame:ClearFrame(nil, nil, "Player Menu")
    else
        frame = vguihandler.GenerateFrame(width, height, "Player Menu", true)
    end

    self.menuFrame = frame

    frame:SetPadding(self.padding, self.padding, self.padding, self.padding)

    self.currentMenuId = MAIN_MENU

    local scrollPanel = vgui.Create("DScrollPanelTTT2", frame)
    scrollPanel:Dock(FILL)

    local dsettings = vgui.Create("DIconLayout", scrollPanel)
    dsettings:Dock(FILL)
    dsettings:SetSpaceX(self.padding)
    dsettings:SetSpaceY(self.padding)

    local tbl = {}
    local perkData = menuDataHandler.CreateNewHelpMenu()

    perkData:BindData(tbl)

    InternalModifyPerkMainMenu(perkData)

    local perkMenuButtons = perkData:GetVisibleNormalMenues()

    AddMenuButtons(perkMenuButtons, dsettings)

    //AddMenuButtons(mainButtons, dsettings)
end

local function func_perk_menu(ply, cmd, args)
    if perk_menu.currentMenuId == MAIN_MENU and IsValid(perk_menu.menuFrame) then
        perk_menu.menuFrame:CloseFrame()

        return
    end

    if perk_menu.currentMenuId and IsValid(perk_menu.menuFrame) and perk_menu.menuFrame:IsFrameHidden() then
        perk_menu.menuFrame:ShowFrame()

        return
    end

    perk_menu:ShowMainMenu()


    /*
    if IsValid(baseFrame) and baseFrame:IsVisible() then
        baseFrame:Close()

        return
    end

    baseFrame = vgui.Create("DFrame")
    baseFrame:SetSize(ScrW() / 2, ScrH() / 2)
    baseFrame:Center()
    baseFrame:SetVisible(true)
    baseFrame:SetDraggable(false)
    baseFrame:ShowCloseButton(true)
    baseFrame.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
    end
    baseFrame:MakePopup()
    */
end
concommand.Add("n_perk_menu", func_perk_menu)
