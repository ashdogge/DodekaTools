require("ISUI/ISPanel");
require ("ISUI/ISTextEntryBox");
require("ISUI/ISLabel")
DKTTextEventPanel = ISPanel:derive("DKTTextEventPanel")

local yPad = 25

function DKTTextEventPanel:createChildren()
    ISPanel.createChildren(self)
    local yPad = self.yPad or 5

        self.panelLabel = ISLabel:new(5, yPad, 25, "Display Text", 1, 1, 1, 1, UIFont.Medium )
        self:addChild(self.panelLabel)
        self.panelLabel:setX(5)

        self.delayLabel = ISLabel:new(5, yPad, 25, "Delay", 1, 1, 1, 1, UIFont.Medium)
        self:addChild(self.delayLabel)
        self.yPad = self.yPad + 25
        self:buildSet()
end

function DKTTextEventPanel:new(x, y, width, height)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.yPad = 5
    o.textEvents = {}
    o.count = 0
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.8 }
    o.borderColor = { r = 1, g = 1, b = 1, a = 0.5 }
    o.cancel = nil
    o.buildSet = nil
    return o 
end
 

function DKTTextEventPanel:buildSet()

    self.count = self.count or 0 -- Initialize if not set
    self.count = self.count + 1
    if self.count > 13 then
        return
    end

    local yPad = self.yPad
    -- Text Entry
    local textEntryBox = ISTextEntryBox:new("Something smells funny...", 5, yPad, self:getWidth() - 100, 20)
    textEntryBox:initialise()
    self:addChild(textEntryBox)
    -- Delay Entry
    local delayEntryBox = ISTextEntryBox:new("0", textEntryBox:getWidth()+10, yPad, 50, 20)
    delayEntryBox:initialise()
    self:addChild(delayEntryBox)
    delayEntryBox:setOnlyNumbers(true)
    delayEntryBox:setMaxTextLength(4)
    self.delayLabel:setX(delayEntryBox:getX())

    -- Button
    if self.count == 1 then
        local textPlusButton = ISButton:new(delayEntryBox:getX() + 55, yPad, 20, 20, "+", self, self.buildSet)
        textPlusButton:initialise()
        self:addChild(textPlusButton)

        local set = {textEntryBox, delayEntryBox, textPlusButton}
            table.insert(self.textEvents, set)

    else
        local removeButt = ISButton:new(delayEntryBox:getX() + 55, yPad, 20, 20, "-", self, self.onRemoveDisplayClick)
        removeButt:initialise()
        self:addChild(removeButt)
        local set = {textEntryBox, delayEntryBox, removeButt}
            table.insert(self.textEvents, set)

    end
    self.yPad = yPad + 25
end