require "ISUI/ISPanel"
require "ISUI/ISTextEntryBox"
require "ISUI/ISButton"
require "ISUI/ISComboBox"
require "ISUI/ISScrollBar"
require "ISUI/ISLabel"
DKTEventForm = ISPanel:derive("DKTEventForm")

function DKTEventForm:new(width, height)
    local o = ISPanel:new(0, 0, width, height)
    setmetatable(o, self)
    self.__index = self
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.8 }
    o.borderColor = { r = 1, g = 1, b = 1, a = 0.5 }
    o.nameEntry = nil
    o.typeOption = nil
    o.triggers = nil
    o.triggerEntries = {} -- Table to store dynamic trigger text boxes
    o.triggerPairs = {} -- Table to store pairs of trigger entries
    o.closeButton = nil
    o.submitButton = nil
    o.labelY = 50 -- Instance-specific labelY
    o.maxHeight = getCore():getScreenHeight() * 0.9 -- Max visible height
    return o
end

function DKTEventForm:createChildren()
    ISPanel.createChildren(self)

    -- Name input
    self.nameEntry = ISTextEntryBox:new("", 80, self.labelY - 2, self.width / 3 , 20)
    self.nameEntry:initialise()
    self.nameEntry:instantiate()
    self:addChild(self.nameEntry)

    self.nameEntry:setMultipleLine(true)
    self.nameEntry:setMaxTextLength(5)
    self.labelY = self.labelY + 40
   
    -- Type dropdown
    self.typeOption = ISComboBox:new(80, self.labelY, 150, 20)
    self.typeOption:initialise()
    self.typeOption:instantiate()
    self.typeOption:addOption("Proximity")
    self.typeOption:addOption("Interaction")
    self.typeOption:addOption("Triggered")
    self:addChild(self.typeOption)
    self.labelY = self.labelY + 40

    -- Trigger button
    self.triggers = ISButton:new(self.width - 60, self.labelY, 25, 25, "+", self, self.onTriggerClicked)
    self.triggers:initialise()
    self.triggers:instantiate()
    self:addChild(self.triggers)
    self.labelY = self.labelY + 40

    -- Submit Button
    self.submitButton = ISButton:new(80, self.labelY, 100, 25, "Submit", self, self.onSubmit)
    self.submitButton:initialise()
    self.submitButton:instantiate()
    self:addChild(self.submitButton)

    -- Close button
    self.closeButton = ISButton:new(self.width - 60, 10, 50, 25, "Cancel", self, self.onClose)
    self.closeButton:initialise()
    self.closeButton:instantiate()
    self.closeButton.backgroundColor = { r = 0.5, g = 0.2, b = 0.2, a = 1.0 }
    self.closeButton.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    self.closeButton.backgroundColorMouseOver = { r = 0.7, g = 0.3, b = 0.3, a = 1.0 }
    self:addChild(self.closeButton)
end

function DKTEventForm:onTriggerClicked()
    if #self.triggerEntries > 22 then
        return
    end

    local lastY = self.triggers:getY()
    if #self.triggerEntries > 0 then
        lastY = self.triggerEntries[#self.triggerEntries]:getY() + 55
    end

    local newEntry = ISButton:new(80, lastY, 150, 50,"", self, self.onEventClicked)
    newEntry:initialise()
        local triggerName = ISLabel:new(75, 5, 20, "New Trigger...", 1, 1, 1, 1, UIFont.Small )
        triggerName:initialise()
        newEntry:addChild(triggerName)
        local triggerType = ISLabel:new(75, 25, 20, "Type: TODO", 1, 1, 1, 1, UIFont.Small )
        triggerType:initialise()
        newEntry:addChild(triggerType)
        local triggerDelete = ISButton:new(120, 0   , 25, 25, "Del", self, self.onDeleteTriggerClicked)
        triggerDelete:initialise()
        newEntry:addChild(triggerDelete)

    -- function ISLabel:new (x, y, height, name, r, g, b, a, font, bLeft)

    self:addChild(newEntry)
    local triggerWid = triggerName:getWidth()
    local triggerTypeWid = triggerType:getWidth()
    triggerName:setX(triggerWid - 40)
    triggerType:setX(triggerTypeWid - 45)
    table.insert(self.triggerEntries, newEntry)

    lastY = lastY + 70

    self.submitButton:setY(lastY)

    local newHeight = lastY + 70 -- Extra padding
    local screenH = getCore():getScreenHeight()
        if self:getY() > (screenH * 0.8) then
        self:setY(self:getY() + 100) 
    end
    self:setHeight(newHeight)

    -- local lastY = self.triggers:getY()
    -- if #self.triggerEntries > 0 then
    --     lastY = self.triggerEntries[#self.triggerEntries]:getY() + 30
    -- end


    -- -- Add two new text entry boxes


    -- local pair = {}
    -- for i = 1, 2 do
    --     local newEntry = ISTextEntryBox:new("", 80, lastY, 150, 20)
    --     newEntry:initialise()
    --     newEntry:instantiate()
    --     self:addChild(newEntry)
    --     table.insert(self.triggerEntries, newEntry)
    --     table.insert(pair, newEntry)
    --     lastY = lastY + 30
    -- end
    -- table.insert(self.triggerPairs, pair)

    -- -- Move trigger and submit buttons below new text boxes
    -- -- self.triggers:setY(lastY)
    -- lastY = lastY + 30
    -- self.submitButton:setY(lastY)

    -- local newHeight = lastY + 50 -- Extra padding
    -- local screenH = getCore():getScreenHeight()

    -- if self:getY() > (screenH * 0.8) then
    --     self:setY(self:getY() + 80) 
    -- end
    -- self:setHeight(newHeight)


    print("Added two trigger text boxes")
end
function DKTEventForm:onDeleteTriggerClicked()
    print(":)")
end
function DKTEventForm:onEventClicked()
    print(":)")
end

function DKTEventForm:onSubmit()
    if not isClient() then
        return
    end
    local player = getPlayer()
    local name = self.nameEntry:getText()
    local eventType = self.typeOption:getOptionText(self.typeOption.selected)
    local triggers = {}
    for i, entry in ipairs(self.triggerEntries) do
        table.insert(triggers, entry:getText())
    end

    local event = { name = name, type = eventType, triggers = triggers, tag = "TestTag" }

    print("Form submitted - Name: " .. name .. ", Type: " .. eventType .. ", Triggers: " .. table.concat(triggers, ", "))
    sendClientCommand(player, "DKT_Tools", "DKTNewEvent", {event})
    self:removeFromUIManager()
end

function DKTEventForm:onClose()
    print("Close button clicked")
    self:removeFromUIManager()
end

function DKTEventForm:prerender()
    ISPanel.prerender(self)
    -- Set stencil to clip content
    local stencilX = 0
    local stencilY = 0
    local stencilX2 = self.width
    local stencilY2 = self.height
    self:setStencilRect(stencilX, stencilY, stencilX2 - stencilX, stencilY2 - stencilY)

    self:drawText("DKT Event Form", 10, 10 , 1, 1, 1, 1, UIFont.Medium)
    self:drawText("Event Name: ", 10, 50 , 1, 1, 1, 1, UIFont.Small)
    self:drawText("Event Type: ", 10, 90 , 1, 1, 1, 1, UIFont.Small)
    self:drawText("Triggers: ", 10, 130 , 1, 1, 1, 1, UIFont.Small)

    for _, button in ipairs(self.triggers) do
            -- local x = pair[1]:getX() - 10 -- Padding
            -- local y = pair[1]:getY() - 5  -- Padding
            -- local width = pair[1]:getWidth() + 20 -- Width of text box + padding
            -- local height = (pair[2]:getY() + pair[2]:getHeight() - pair[1]:getY()) + 10 -- Height to cover both + padding
            -- self:drawRect(x, y, width, height, 0.25, 1, 1, 1)
            -- self:drawRectBorder(x, y, width, height, 0.25, 0.0, 0.0, 1) -- White border
    end
    self:clearStencilRect()
end

function DKTEventForm.test()

    local height = 210
    local screenW = getCore():getScreenWidth()
    local screenH = getCore():getScreenHeight()
    local width = screenW * 0.9
    local x = (screenW - width) / 2
    local y = (screenH - height) / 2

    local window = DKTEventForm:new(width, height)
    window:setX(x)
    window:setY(y)
    window:initialise()
    window:instantiate()
    window:addToUIManager()
end


