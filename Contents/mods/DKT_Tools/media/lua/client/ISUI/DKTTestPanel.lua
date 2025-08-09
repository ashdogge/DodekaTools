
require("ISUI/ISButton");
require("ISUI/ISCollapsableWindow");
require ("ISUI/ISTextEntryBox");
require("ISUI/ISScrollingListBox")
TestPanel = ISCollapsableWindow:derive("TestPanel")

local yPad = 25

function TestPanel:populateItems()
    
    local nitems = getAllItems()
    local size = nitems:size()

    for i = size-1, 0, -1 do
        local item = nitems:get(i)
        table.insert(TestPanel.items, item)
    end
end

function TestPanel:createChildren()
    ISCollapsableWindow.createChildren(self)
    
    local buttonW = (self:getWidth() - 45)
    local buttonH = 25




    local searchBar = ISTextEntryBox:new("Search...", 25, yPad, self.width - 45 , 20)
    searchBar:initialise()
    searchBar.onTextChange = function() self:onTextChange() end
    self.searchBar = searchBar
    self:addChild(searchBar)
    yPad = yPad + 35

    local searchList = ISScrollingListBox:new(25, yPad, self.width - 45, self.height - 100)
    searchList:initialise()
    self.searchList = searchList
    self:addChild(searchList)
    yPad = yPad + 35

    local newButt = ISButton:new(25, yPad + searchList:getHeight() - 15, buttonW, buttonH, "Submit", self, self.onClicked )
    newButt:initialise() 
    self:addChild(newButt)

    self.populateItems()
    for i, item in ipairs(self.items) do
        searchList:addItem(item:getDisplayName())
    end

    --     for i, entry in ipairs(self.triggerEntries) do
    --     table.insert(triggers, entry:getText())
    -- end
end

function TestPanel:onTextChange()
    self.searchString = self.searchBar:getText()
    self.searchList:clear() -- Clear the current list
    if self.searchString == "" then
        -- If search is empty, show all items
        for i, item in ipairs(self.items) do
            self.searchList:addItem(item:getDisplayName())
        end
    else
        -- Filter items based on search string
        for i, item in ipairs(self.items) do
            local displayName = item:getDisplayName():lower()
            if displayName:find(self.searchString:lower(), 1, true) then
                self.searchList:addItem(item:getDisplayName())
            end
        end
    end
end


function TestPanel:onClicked(button)
    self.searchString = self.searchBar:getText()


end 

function TestPanel:new(x, y, width, height)
    local o = ISCollapsableWindow:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    o.title = "Test Panel :)"
    o.yPad = nil
    o.searchString = nil
    o.searchList = nil
    self.items={}
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