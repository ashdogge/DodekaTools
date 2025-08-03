require "ISUI/ISPanel"
require "ISUI/ISTextEntryBox"
require "ISUI/ISButton"
require "ISUI/ISComboBox"
DKTEventForm = ISPanel:derive("DKTEventForm")
local labelY = 50

function DKTEventForm:new(width, height)
    local o = ISPanel:new(0,0,width,height)
    setmetatable(o, self)
    self.__index = self
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.8 }
    o.borderColor = { r = 1, g = 1, b = 1, a = 0.5 }
    o.nameEntry = nil
    o.typeOption = nil
    o.triggers = nil
    o.triggerEntries = {} -- Table to store dynamic trigger text boxes
    o:initialise()
    o.scrollChildren = true
    o.scrollBarWidth = 10
    o:setScrollHeight(height)
    return o
end

function DKTEventForm:createChildren()
    ISPanel.createChildren(self)
    

    -- name input
    self.nameEntry = ISTextEntryBox:new("", 80, labelY - 2, 150, 20)
    self.nameEntry:initialise()
    self.nameEntry:instantiate()
    self:addChild(self.nameEntry)
    labelY = labelY + 40

    -- Type dropdown
    self.typeOption = ISComboBox:new(80, labelY, 150, 20)
    self.typeOption:initialise()
    self.typeOption:instantiate()
    self.typeOption:addOption("Proximity") 
    self.typeOption:addOption("Interaction") 
    self.typeOption:addOption("Triggered") 
    self:addChild(self.typeOption)
    labelY = labelY + 40

    -- New Trigger button
    self.triggers = ISButton:new(80, labelY, 25, 25, "+", self, self.onTriggerClicked)
    self.triggers:initialise()
    self.triggers:instantiate()
    self:addChild(self.triggers)
    labelY = labelY + 40

    -- Submit Button
    self.submitButton = ISButton:new(80, labelY, 100, 25, "Submit", self, self.onSubmit)
    self.submitButton:initialise()
    self.submitButton:instantiate()
    self:addChild(self.submitButton)

    -- Close button
    self.closeButton = ISButton:new(190, 10, 50, 25, "Cancel", self, self.onClose)
    self.closeButton:initialise()
    self.closeButton:instantiate()
    self.closeButton.backgroundColor = { r = 0.5, g = 0.2, b = 0.2, a = 1.0 } -- Reddish background
    self.closeButton.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    self.closeButton.backgroundColorMouseOver = { r = 0.7, g = 0.3, b = 0.3, a = 1.0 }
    self:addChild(self.closeButton)
    labelY = 50
end

function DKTEventForm:onSubmit()
    if not isClient() then
        return 
    end
    local player = getPlayer()
    local name = self.nameEntry:getText()

    local event = {name, "11", "TestTag"}

    print("Form submitted- Name: " .. name )
    sendClientCommand(player, "DKT_Tools", "DKTNewEvent", {event})
    self:removeFromUIManager()
end
function DKTEventForm:onClose()
    print("Close button clicked")
    self:removeFromUIManager()
end

function DKTEventForm:onTriggerClicked()
    local lastY = self.triggers:getY()
    if #self.triggerEntries > 0 then
        lasyY = self.triggerEntries[#self.triggerEntries]:getY() + 30
    end

    local newEntry = ISTextEntryBox:new("", 80, lastY, 150, 20)
    newEntry:initialise()
    newEntry:instantiate()
    self:addChild(newEntry)
    table.insert(self.triggerEntries, newEntry)
    lastY = lastY + 30

    self.submitButton:setY(lastY)

    local newHeight = lastY + 50
    if newHeight > self.height then
        self:setScrollHeight(newHeight)
        self.height = math.min(newHeight, getCore():getScreenHeight() * 0.8)
    end
end
function DKTEventForm:prerender()
ISPanel.prerender(self)
    -- Draw title and labels
    self:drawText("DKT Event Form", 10, 10, 1, 1, 1, 1, UIFont.Medium)
    self:drawText("Event Name: ", 10, 50, 1, 1, 1, 1, UIFont.Small)
    self:drawText("Event Type: ", 10, 90, 1, 1, 1, 1, UIFont.Small)
    self:drawText("Triggers: ", 10, 130, 1, 1, 1, 1, UIFont.Small)
end

function DKTEventForm.test()
    local width = 300
    local height = 210

    local screenW = getCore():getScreenWidth()
    local screenH = getCore():getScreenHeight()
    local x = (screenW - width) / 2
    local y = (screenH - height) / 2

    local window = DKTEventForm:new(width, height, 300, 210)
    window:setX(x) -- Set calculated x
    window:setY(y) -- Set calculated y
    window:initialise()
    window:instantiate()
    window:addToUIManager()
end