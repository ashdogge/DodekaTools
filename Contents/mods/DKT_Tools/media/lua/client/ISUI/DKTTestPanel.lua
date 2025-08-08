
require("ISUI/ISButton");
require("ISUI/ISCollapsableWindow");

TestPanel = ISCollapsableWindow:derive("TestPanel")

local yPad = 25
function TestPanel:createChildren()
    ISCollapsableWindow.createChildren(self)
    
    local buttonW = (self:getWidth() - 50)
    local buttonH = 25


    for i = 1, 20 do
        local newButt = ISButton:new(25, yPad, buttonW, buttonH, "=)", self, self.onClicked )
        newButt:initialise()
        self:addChild(newButt)
        self:addScrollBars()
        yPad = yPad + 35
    end


end

function TestPanel:onClicked(button)
    local i = (ZombRand(6) + 1)
    button.title = self.strings[i]
    print("I'm just a funny little guy")

end 

function TestPanel:new(x, y, width, height)

    local o = ISCollapsableWindow:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.title = "Test Panel :)"
    o.strings = {"Ow!", "Stop!", "That hurts!", "Quit it!", "Enough!", "Stop that!"}
    o.yPad = nil
    return o 
end

function createTestPanel()

    local screenH = getCore():getScreenHeight()
    local screenW = getCore():getScreenWidth()
    local panel = TestPanel:new((screenW / 4), (screenH / 4), (screenW / 2), (screenH/2))

    panel:initialise()
    
    panel:addToUIManager()

end

function onKeyPress(key)
    if key == Keyboard.KEY_L then
        createTestPanel()
    end
end
Events.OnKeyPressed.Add(onKeyPress) 