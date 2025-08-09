
require("ISUI/ISButton");
require("ISUI/ISCollapsableWindow");
require "ISUI/ISTextEntryBox"
require "ISUI/ISComboBox"
DKTEventEditor = ISCollapsableWindow:derive("DKTEventEditor")

local yPad = 25

function DKTEventEditor:createChildren()
    ISCollapsableWindow.createChildren(self)

    local itemWidth = (self:getWidth() - 90)
    
    self.effectSelector = ISComboBox:new(5, yPad, 150, 20, self, self.onEffectChange)
    
    self.effectSelector:initialise()
    self.effectSelector:instantiate()
    self.effectSelector:addOption("Spawn Item")
    self.effectSelector:addOption("Player Effect")
    self.effectSelector:addOption("Display Text")
    self.effectSelector:addOption("Trigger Progression")
    self:addChild(self.effectSelector)
    yPad = 25


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
    o.strings = {"Ow!", "Stop!", "That hurts!", "Quit it!", "Enough!", "Stop that!"}
    o.yPad = nil
    o.textBox = nil
    o.itemSelector = nil
    return o 
end

-- local eventType = self.typeOption:getOptionText(self.typeOption.selected)
function DKTEventEditor:onEffectChange()

    local selected = self.effectSelector:getOptionText(self.effectSelector.selected)
    
    if selected == "Spawn Item" then
        if self.itemMenu == nil then
            self.itemMenu = ISTextEntryBox:new("Text to display here...", 5, yPad, 500, 300)
            self.itemMenu:initialise()
            self:addChild(self.itemMenu)
            self.itemMenu:setMultipleLine(true)
            self.itemMenu:setMaxLines(50)
            self.itemMenu:addScrollBars()
            
        else
            self.itemMenu:setVisible(true)
        end
    else
        if self.itemMenu then
            self.itemMenu:setVisible(false)
        end
    end


    -- Logic for displaying text above point
    if selected == "Display Text" then
        if self.textBox == nil then
            self.textBox = ISTextEntryBox:new("Text to display here...", 5, yPad, 500, 300)
            self.textBox:initialise()
            self:addChild(self.textBox)
            self.textBox:setMultipleLine(true)
            self.textBox:setMaxLines(50)
            self.textBox:addScrollBars()
            
        else
            self.textBox:setVisible(true)
        end
    else
        if self.textBox then
            self.textBox:setVisible(false)
        end
    end
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