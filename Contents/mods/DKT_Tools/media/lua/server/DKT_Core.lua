local DKT_Core = DKT_Core or {}
local debugging = true
local modData
local faction
-- Initialize global ModData on the server
Events.OnInitGlobalModData.Add(function()
    if isServer() then
        -- Init modData
        modData = ModData.getOrCreate("DKT")
        if not modData.activePlayers then
            modData.activePlayers = {}
        end
        ModData.add("DKT", modData)
        ModData.transmit("DKT")

    end
end)

saveData = saveData or {}
Events.OnInitGlobalModData.Add(function()
    if isServer() then
        factions = Faction.getFactions()
            if factions == nil or factions:isEmpty() then
            print("No factions found.")
            return
        end
        for i = 0, factions:size() -1 do
        
        end
    end
end
)
-- Initialize faction if faction does not exist
local function printFactions()
    if factions == nil or factions:isEmpty() then
        print("No factions found.")
        return
    end

    for i = 0, factions:size() -1 do
        local faction = factions:get(i)
        local factionName = faction:getName()
        print("Faction: " .. factionName)
        local factionTag = faction:getTag()
        local factionTagColor = faction:getTagColor()
        print("Faction tag: " .. factionTag)
    end
end
    

local function toggleStatus(player, args)
    local clicked = args.status
    local name = player:getUsername()
    if isServer() then
        if clicked then
            faction:addPlayer(name)
            print("Added " .. name .. "to " .. faction:getName())
        else 
            faction:removePlayer(name)
            print("Removed ".. name .. "from " .. faction:getName())
        end
    end
end

local function onClientCommand(module, command, player, args)
    if module == "DKT_Tools" then
        if command == "toggleStatus" then
            print("Calling toggleStatus for player: " .. player:getDisplayName())
            toggleStatus(player, args)
    elseif command == "printStatus" then
        print("Calling printStatus for player: " .. player:getDisplayName())
            writeToFile(modData.activePlayers)
        end
    end
end

Events.OnClientCommand.Add(onClientCommand)






function DKT_Core.OnEveryHour()
    if debugging then
        print("< DKT_Core: ACTIVE >")
    end
    printFactions()
end

Events.EveryHours.Add(DKT_Core.OnEveryHour)

return DKT_Core