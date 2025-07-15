require("ISUI/ISPanel");
require("ISUI/ISButton");
require("ISUI/ISCollapsableWindow");
require("DKT_Core")
local debugging = true

local function log(msg)
    if debugging then
        print("<**DKTControl.lua**>")
        print(msg)
    end
end

 DKTControlPanel = ISCollapsableWindow:derive("DKTControlPanel")
-- Override createChildren to customize buttons
 function DKTControlPanel:createChildren()
    ISCollapsableWindow.createChildren(self)
    -- Hide close button 
    if self.closeButton then
        self.closeButton:setVisible(false)
    end

    -- Configure collapse button for minimize/maximize
    if self.collapseButton then
        self.collapseButton:setVisible(true) -- Always show unless pinned
        self.collapseButton:setImage(self.collapseButtonTexture)
    end

    if self.pinButton then
        self.pinButton:setVisible(not self.pin) -- Show pin button if not pinned
    end
    
    if self.pinButton then
        self.pinButton:setVisible(false)
    end
-- Define simple button props
    local buttonWidth = 25
    local buttonHeight = 25
    local buttonX = (self.width - buttonWidth) /2
    local buttonY = self:titleBarHeight() +20
    -- Create a new instance of ISButton 
    self.testButton = ISButton:new(buttonX, buttonY, buttonWidth, buttonHeight, "RP", self, DKTControlPanel.onTestButtonClick)
    self.printButton = ISButton:new(buttonX-105, buttonY, buttonWidth, buttonHeight, "Print Button", self, DKTControlPanel.onPrintButtonClick)
-- Configure button properties

    self.testButton:initialise()
        local player = getPlayer()

    if Faction.factionExist("LFRP") then
        local faction = Faction.getFaction("LFRP")
        if faction:isPlayerMember(player) then
            self.testButton.backgroundColor = {r=0.518, g=0.71, b=0.165, a=1}    
        else
        self.testButton.backgroundColor = {r=0.2, g=0.2, b=0.2, a=1}
        end
    end
    self.testButton.borderColor = {r=0.4, g=0.4, b=0.4, a=1}
    self.testButton.backgroundColorMouseOver = {r=0.3, g=0.3, b=0.3, a=1}

    -- Add button to the panel
    self:addChild(self.testButton)

    self.printButton:initialise()
    self.printButton.borderColor = {r=0.4, g=0.4, b=0.4, a=1}
    self.printButton.backgroundColor = {r=0.2, g=0.2, b=0.2, a=1}
    self.printButton.backgroundColorMouseOver = {r=0.3, g=0.3, b=0.3, a=1}
    
    self:addChild(self.printButton)
end

-- Button click function
function DKTControlPanel:onTestButtonClick(button)
    -- self.isClicked = not self.isClicked
    local player = getPlayer()
    if player then
       local name = player:getUsername()

        -- Check if faction exists
        if Faction.factionExist("LFRP") then
            
                log("DKT: LFRP Faction exists")
                local faction = Faction.getFaction("LFRP")
            -- Check if player is in faction
                if not faction:isPlayerMember(player) then
                -- If player is not in faction, join faction, set isClicked to true
                log("Adding player " .. name .. " to faction")
                faction:addPlayer(name)
                self.isClicked = true
                else
                -- If player is in faction, leave faction, set isClicked to false
                log("Player already in faction, removing")
                faction:removePlayer(name)
                self.isClicked = false
                end
            else
                -- If faction does not exist, create the faction, add player, set isClicked=true
                local faction  = Faction.createFaction("LFRP", "Admin")
                local color = ColorInfo.new(0.639, 0.859, 0.224, 1)
                faction:setTag("LFRP")
                faction:addPlayer(name)
                faction:setTagColor(color)
                self.isClicked = true
        end


    else
        log("ERROR: No player found")
    end
        if self.isClicked then 
        self.testButton.backgroundColor = {r=0.518, g=0.71, b=0.165, a=1}
    else
        self.testButton.backgroundColor = {r=0.2, g=0.2, b=0.2, a=1}
    end
end

function DKTControlPanel:onPrintButtonClick(button)
    log("Print button clicky")
    local player = getPlayer()
    sendClientCommand(player, "DKT_Tools", "printStatus", {})
end

-- Override collapse to handle minimize/maximize
function DKTControlPanel:collapse()
    if self.isCollapsed then
        -- Maximize: Restore full size
        self.isCollapsed = false
        self:clearMaxDrawHeight()
        self.testButton:setVisible(true)
        self.printButton:setVisible(true)
        if self.pinButton then
            self.pinButton:setVisible(not self.pin)
        end
        if self.collapseButton then
            self.collapseButton:setVisible(self.pin)
        end
    else
        -- Minimize: Collapse to title bar
        self.isCollapsed = true
        self:setMaxDrawHeight(self:titleBarHeight())
        self.testButton:setVisible(false)
        self.printButton:setVisible(false)
        if self.pinButton then
            self.pinButton:setVisible(not self.pin)
        end
        if self.collapseButton then
            self.collapseButton:setVisible(self.pin)
        end
    end
end

-- Override pin to lock/unlock maximized state
function DKTControlPanel:pin()
    self.pin = true
    self.isCollapsed = false
    self:clearMaxDrawHeight()
    self.testButton:setVisible(true)
    self.printButton:setVisible(true)
    if self.collapseButton then
        self.collapseButton:setVisible(true)
    end
    if self.pinButton then
        self.pinButton:setVisible(false)
    end
end

-- Override uncollapse to ensure proper maximization
function DKTControlPanel:uncollapse()
    self.isCollapsed = false
    self:clearMaxDrawHeight()
    self.testButton:setVisible(true)
    self.printButton:setVisible(true)
    if self.pinButton then
        self.pinButton:setVisible(not self.pin)
    end
    if self.collapseButton then
        self.collapseButton:setVisible(self.pin)
    end
end

-- Constructor with debug check
function DKTControlPanel:new(x, y, width, height)
    if not ISCollapsableWindow then
        log("ERROR: ISCollapsableWindow is nil")
        return nil
    end
    local o = ISCollapsableWindow:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.title = "DKT-CTRL"
    o.isClicked = false
    o.pin = false -- Start unpinned to allow collapse

    return o
end

local dktPanelInstance = nil
function createDKTControlPanel()
    if dktPanelInstance then
        dktPanelInstance:setVisible(true)
        return
    end
    local panel = DKTControlPanel:new(100, 100, 200, 150)
    if not panel then
        log("ERROR: Failed to create DKTControlPanel")
        return
    end
    panel:initialise()
    panel:addToUIManager()
    panel:setVisible(true)
    dktPanelInstance = panel
end

-- Events.OnGameStart.Add(createDKTControlPanel)
function onKeyPress(key)
    if key == Keyboard.KEY_P then
        createDKTControlPanel()
    end
end
Events.OnKeyPressed.Add(onKeyPress)