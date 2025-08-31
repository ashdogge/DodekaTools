
require("ISUI/ISButton");
require("ISUI/ISPanel");
require "ISUI/ISTextEntryBox"
require "ISUI/ISComboBox"
require("ISUI/ISPanel")
require("DKTItemPicker")
require("DKTTextEvent")
require("DKTTextEffectPanel")
require("ISUI/ISLabel")
DKTEffectEditor = ISPanel:derive("DKTEffectEditor")

function DKTEffectEditor:createChildren()
    ISPanel.createChildren(self)

    local itemWidth = (self:getWidth() - 90)
    
    self.effectSelector = ISComboBox:new(5, 25, 150, 20, self, self.onEffectChange)
    self.effectSelector:initialise()
    self.effectSelector:instantiate()
    self.effectSelector:addOption("Spawn Item")
    self.effectSelector:addOption("Player Effect")
    self.effectSelector:addOption("Display Text")
    self.effectSelector:addOption("Trigger Progression")
    self:addChild(self.effectSelector)

    self.effectName = ISTextEntryBox:new("Effect name...", 160, 25, 300, 20)
    self.effectName:initialise()
    self.effectName:instantiate()
    self:addChild(self.effectName)

    self.effectName:setMaxTextLength(15)

    self.cancel = ISButton:new(self.width - 60, 10, 50, 25, "Cancel", self, self.onClose)
    self.cancel:initialise()
    self.cancel.backgroundColor = { r = 0.5, g = 0.2, b = 0.2, a = 1.0 }
    self.cancel.borderColor = { r = 0.4, g = 0.4, b = 0.4, a = 1 }
    self.cancel.backgroundColorMouseOver = { r = 0.7, g = 0.3, b = 0.3, a = 1.0 }
    self:addChild(self.cancel)

    self.lastY = self.lastY + 30

end

function DKTEffectEditor:new(x, y, width, height, button)
    local o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.title = "DKT Effect Editor"
    o.textPanel = nil
    o.itemSelector = nil
    o.lastY = 30
    o.textEvents = {}
    o.buttonCount = 0
    o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.8 }
    o.borderColor = { r = 1, g = 1, b = 1, a = 0.5 }
    o.cancel = nil
    o.triggerButton = button
    o.effectName = nil
    print(self.triggerButton)
    return o 
end

function DKTEffectEditor:onClose()        
    self:removeFromUIManager()
end

function DKTEffectEditor:onEffectChange()
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

function DKTEffectEditor:createDisplayTextInput()
    -- TODO: Move to its own file
            local panelW = self:getWidth()
            local panelH = self:getHeight()
            self.textPanel = DKTTextEffectPanel:new(5, self.lastY, panelW - 10, panelH - 70, self.triggerButton )
            self:addChild(self.textPanel)

end 

function DKTEffectEditor:onNewDisplayClick()
    local panelW = self:getWidth()
    local panelH = self:getHeight()
    self.buttonCount = self.buttonCount or 0 -- Initialize if not set
    self.buttonCount = self.buttonCount + 1
    if self.buttonCount > 13 then
        return
    end
    self.textPanel.yPad = self.textPanel.yPad or 5 -- Initialize if not set

    -- Text box
    local newTextEntryBox = ISTextEntryBox:new("Something smells funny...", 5, self.textPanel.yPad, panelW - 100, 20)
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


end





function createDKTEffectEditor()

    local screenH = getCore():getScreenHeight()
    local screenW = getCore():getScreenWidth()
    local panel = DKTEffectEditor:new((screenW / 4), (screenH / 4), (screenW / 2), (screenH/2))

    panel:initialise()
    
    panel:addToUIManager()

end

function onKeyPress(key)
    if key == Keyboard.KEY_I then
        createDKTEffectEditor()
    end
end
Events.OnKeyPressed.Add(onKeyPress) 