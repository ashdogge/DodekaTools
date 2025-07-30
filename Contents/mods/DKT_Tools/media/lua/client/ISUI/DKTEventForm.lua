require "ISUI/ISPanel"
require "ISUI/ISTextEntryBox"
require "ISUI/ISButton"

DKTEventForm = ISPanel:derive("DKTEventForm")

function DKTEventForm:new(x, y, width, height)
    local o = ISPanel:new(x,y,width,height)
    setmetatable(o, self)
    self.__index = self
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.8 }
    o.borderColor = { r = 1, g = 1, b = 1, a = 0.5 }
    o.nameEntry = nil

    o.submitButton = nil
    return o
end

function DKTEventForm:createChildren()
    ISPanel.createChildren(self)

    local labelY = 50
    self:drawText("Name: ", 20, labelY, 1, 1, 1, 1, UIFont.Small)
    
    self.nameEntry = ISTextEntryBox:new("", 80, labelY - 2, 150, 20)
    self.nameEntry:initialise()
    self.nameEntry:instantiate()
    -- self.nameEntry:setOnlyLetters(true)
    self:addChild(self.nameEntry)
    
    labelY = labelY + 40
    self:drawText("Age: ", 20, labelY, 1, 1, 1, 1, UIFont.Small)

   

    labelY = labelY + 40
    self.submitButton = ISButton:new(80, labelY, 100, 25, "Submit", self, self.onSubmit)
    self.submitButton:initialise()
    self.submitButton:instantiate()
    self:addChild(self.submitButton)
end

function DKTEventForm:onSubmit()
    local player = getPlayer()
    local name = self.nameEntry:getText()

    local event = {name, "11", "TestTag"}

    print("Form submitted- Name: " .. name )
    sendClientCommand(player, "DKT_Tools", "DKTNewEvent", {event})
    self:removeFromUIManager()
end

function DKTEventForm:prerender()
ISPanel.prerender(self)
    -- Draw title and labels
    self:drawText("DKT Event Form", 10, 10, 1, 1, 1, 1, UIFont.Medium)
    self:drawText("Event Name: ", 10, 50, 1, 1, 1, 1, UIFont.Small)
end

function DKTEventForm.test()
    local window = DKTEventForm:new(200, 200, 300, 150)
    window:initialise()
    window:instantiate()
    window:addToUIManager()
end