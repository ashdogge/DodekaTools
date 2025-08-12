
require("ISUI/ISButton");
require("ISUI/ISCollapsableWindow");
require "ISUI/ISTextEntryBox"
require "ISUI/ISComboBox"
require("ISUI/ISPanel")
require("DKTItemPicker")
require("DKTTextEvent")
require("ISLabel")
DKTEventEditor = ISCollapsableWindow:derive("DKTEventEditor")

function DKTEventEditor:createChildren()
    ISCollapsableWindow.createChildren(self)

    local itemWidth = (self:getWidth() - 90)
    
    self.effectSelector = ISComboBox:new(5, 25, 150, 20, self, self.onEffectChange)
    
    self.effectSelector:initialise()
    self.effectSelector:instantiate()
    self.effectSelector:addOption("Spawn Item")
    self.effectSelector:addOption("Player Effect")
    self.effectSelector:addOption("Display Text")
    self.effectSelector:addOption("Trigger Progression")
    self:addChild(self.effectSelector)
    self.lastY = self.lastY + 30


    -- local buttonW = (self:getWidth() - 50)
    -- local buttonH = 25


    -- for i = 1, 20 do
    --     local newButt = ISButton:new(25, yPad, buttonW, buttonH, "=)", self, self.onClicked )
    --     newButt:initialise()
    --     self:addChild(newButt)
    --     self:addScrollBars()
    --     yPad = yPad + 35
    -- end


end

function DKTEventEditor:onClicked(button)
    local i = (ZombRand(6) + 1)
    button.title = self.strings[i]
    print("I'm just a funny little guy")

end 

function DKTEventEditor:new(x, y, width, height)

    local o = ISCollapsableWindow:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.title = "Test Panel :)"
    o.textPanel = nil
    o.itemSelector = nil
    o.lastY = 30
    o.textEvents = {}
    o.buttonCount = 0

    return o 
end

-- local eventType = self.typeOption:getOptionText(self.typeOption.selected)
function DKTEventEditor:onEffectChange()
    local panelW = self:getWidth()
    local panelH = self:getHeight()
    local selected = self.effectSelector:getOptionText(self.effectSelector.selected)
    if selected == "Spawn Item" then
        if self.itemMenu == nil then
            self.lastY = self.effectSelector:getY() + 25
            self.itemMenu = DKTItemPicker:new(5, self.lastY, 500, 300)
            self.itemMenu:initialise()
            self:addChild(self.itemMenu)
        else
            self.itemMenu:setVisible(true)
        end
    else
        if self.itemMenu then
            self.itemMenu:setVisible(false)
        end
    end


    -- Logic for Display Text effect menu
    if selected == "Display Text" then
        if self.textBox == nil then
            self:createDisplayTextInput()
        else
            self.textPanel:setVisible(true)
        end
    else
        if self.textPanel then
            self.textPanel:setVisible(false)
        end
    end
end

function DKTEventEditor:createDisplayTextInput()
            local panelW = self:getWidth()
            local panelH = self:getHeight()
            self.textPanel = ISPanel:new(5, self.lastY, panelW - 10, panelH - 70 )
            self.textPanel:initialise()
            self.textPanel.yPad = 5
            local yPad = self.textPanel.yPad
            local panelLabel = ISLabel:new(5, yPad, 25, "Display Text", 1, 1, 1, 1, UIFont.Medium )
            self.textPanel:addChild(panelLabel)
            panelLabel:setX(5)
            local delayLabel = ISLabel:new(5, yPad, 25, "Delay", 1, 1, 1, 1, UIFont.Medium)
            self.textPanel:addChild(delayLabel)
            yPad = yPad + 25

            local textEntryBox = ISTextEntryBox:new("Something smells funny...", 5, yPad, panelW - 150, 20)
            textEntryBox:initialise()
            
            local delayEntryBox = ISTextEntryBox:new("0", textEntryBox:getWidth()+10, yPad, 50, 20)
            delayEntryBox:initialise()
            self.textPanel:addChild(delayEntryBox)
            delayEntryBox:setOnlyNumbers(true)
            delayEntryBox:setMaxTextLength(4)
            delayLabel:setX(delayEntryBox:getX())

            local textPlusButton = ISButton:new(delayEntryBox:getX() + 55, yPad, 20, 20, "+", self, self.onNewDisplayClick)
            textPlusButton:initialise()
            self.textPanel:addChild(textPlusButton)
            self.textPanel.yPad = yPad + 25
            
            self.textPanel:addChild(textEntryBox)
            
            self:addChild(self.textPanel)

end

function DKTEventEditor:onNewDisplayClick()
    local panelW = self:getWidth()
    local panelH = self:getHeight()
    self.buttonCount = self.buttonCount or 0 -- Initialize if not set
    self.buttonCount = self.buttonCount + 1
    self.textPanel.yPad = self.textPanel.yPad or 5 -- Initialize if not set

    -- Text box
    local newTextEntryBox = ISTextEntryBox:new("Something smells funny...", 5, self.textPanel.yPad, panelW - 150, 20)
    newTextEntryBox:initialise()
    self.textPanel:addChild(newTextEntryBox)

    -- Delay counter
    local delayEntryBox = ISTextEntryBox:new("0", newTextEntryBox:getWidth() + 10, self.textPanel.yPad, 50, 20)
    delayEntryBox:initialise()
    self.textPanel:addChild(delayEntryBox)
    delayEntryBox:setOnlyNumbers(true)
    delayEntryBox:setMaxTextLength(4)
    -- "-"" button to remove a line
    local removeButt = ISButton:new(delayEntryBox:getX() + 55, self.textPanel.yPad, 20, 20, "-", self, self.onRemoveDisplayClick)
    removeButt:initialise()
    self.textPanel:addChild(removeButt)

    local entrySet = {newTextEntryBox, delayEntryBox, removeButt}
    table.insert(self.textEvents, entrySet)
    self.textPanel.yPad = self.textPanel.yPad + 25

    removeButt.set = {newTextEntryBox, delayEntryBox}
end

function DKTEventEditor:onRemoveDisplayClick(button)
    local boxes = button.set
    local par = button:getParent()

    -- Remove the text and delay entry boxes from the parent panel
    for k, v in ipairs(boxes) do
        par:removeChild(v)
    end
    -- Remove the button itself
    par:removeChild(button)

    -- Remove the entrySet from self.textEvents and update buttonCount
    for i, entrySet in ipairs(self.textEvents) do
        if entrySet[1] == boxes[1] and entrySet[2] == boxes[2] then
            table.remove(self.textEvents, i)
            self.buttonCount = self.buttonCount - 1
            break -- Exit loop after removal to avoid index issues
        end
    end

    -- Reposition remaining elements
    local ypad = 55 -- Start at initial yPad (adjust if different in createDisplayTextInput)
    for _, entrySet in ipairs(self.textEvents) do
        for k, v in ipairs(entrySet) do
            v:setY(ypad)
        end
        ypad = ypad + 25
    end
    self.textPanel.yPad = ypad -- Update yPad to the new bottom position
end

function createDKTEventEditor()

    local screenH = getCore():getScreenHeight()
    local screenW = getCore():getScreenWidth()
    local panel = DKTEventEditor:new((screenW / 4), (screenH / 4), (screenW / 2), (screenH/2))

    panel:initialise()
    
    panel:addToUIManager()

end

function onKeyPress(key)
    if key == Keyboard.KEY_I then
        createDKTEventEditor()
    end
end
Events.OnKeyPressed.Add(onKeyPress) 