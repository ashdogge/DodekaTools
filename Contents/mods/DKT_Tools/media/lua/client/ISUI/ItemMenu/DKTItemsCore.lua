DKTItemCore = {}
DKTItemCore.categories = {
	"All",
	"Normal",
	"Weapon",
	"Food",
	"Literature",
	"Drainable",
	"Clothing",
	"Container",
	"WeaponPart",
	"Key",
	"Moveable",
	"Radio",
	"AlarmClock",
    "AlarmClockClothing"
}

function DKTItemCore.getItems()
    DKTItemCore.items = {}
    for i = 1, #DKTItemCore.categories do
        DKTItemCore.items[DKTItemCore.categories[i]] = {}
    end

    local items = getAllItems()
    local size = items:size()
    for i = size-1,0,-1 do
        local item = items:get(i)
        local invItem = instanceItem(item)
        if instanceItem then
            DKTItemCore.items[item:getTypeString()] = DKTItemCore.items[invItem:getDisplayCategory()] or {}
            table.insert(DKTItemCore.items[invItem:getDisplayCategory()], item)
        end
    end

end

function DKTItemCore.sort(func)
    for k,v in pairs(DKTItemCore.items) do
        table.sort(DKTItemCore.items[k], func)
    end
end