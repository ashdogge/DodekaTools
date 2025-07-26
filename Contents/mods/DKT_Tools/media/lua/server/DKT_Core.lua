local DKT_Core = DKT_Core or {}
local debugging = true
local modData

-- Initialize global ModData on the server
Events.OnInitGlobalModData.Add(function()
    if isServer() then
        -- Init modData
        modData = ModData.getOrCreate("DKT_Tools")
        if not modData.activePlayers then
            modData.activePlayers = {}
        end

            modData.events = {"eventOne", "EventTwo"}

        -- DKT_Tools has tables activePlayers and events
        ModData.add("DKT_Tools", modData)
        -- Init Factions tracking
        if Faction.factionExist("LFRP") then
            faction = Faction.getFaction("LFRP")
            print("Faction LFRP exists")
        else
            print("Faction not found, creating:")
            Faction.createFaction("LFRP", "Admin")
            faction = Faction.getFaction("LFRP")
            faction:setTag("LFRP")
        end
    end
end)

saveData = saveData or {}
-- local faction = Faction.getFaction("LFRP") local players = faction:getPlayers() print(players) local player = players:get(0) print (player)
local function writeToFile()
    print("writeToFile called")
    if isServer() then
        local faction = Faction.getFaction("LFRP")
        local rawMembers = faction:getPlayers()
        
        local factionMembers = {}
        for i = 0, rawMembers:size() - 1 do
            table.insert(factionMembers, rawMembers:get(i))
        end

        local file = getModFileWriter("DKT_Tools", "media/ui/data.txt", true, false)
        print("Faction Members:", table.concat(factionMembers, ", "))

        for _i, v in ipairs(factionMembers) do
            local player = nil
            for i = 0, getOnlinePlayers():size() - 1 do
                local onlinePlayer = getOnlinePlayers():get(i)
                if onlinePlayer:getUsername() == v then
                    player = onlinePlayer
                    break
                end
            end

            print("Resolved player for", v, "->", player)

            local x = player and (player:getX() / 150) or "?"
            local y = player and (player:getY() / 150) or "?"
            -- Don't write to file if player is offline
            if x == "?" and y == "?" then
                
            else
        
            file:write(v .. "," .. x .. "," .. y .. "\n")
            end
        end

        file:close()
        print("writeToFile fin")
    end
end



local function printFactions()
    if isServer() then
        print("PrintFactions")
        local activePlayers = faction:getPlayers()
        writeToFile(activePlayers)
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
        elseif command == "DKTEvent" then
            print("Calling DKTEvent called by" .. player:getDisplayName())
        end
    end
end

Events.OnClientCommand.Add(onClientCommand)



-- function DKT_Core.OnEveryHour()
--     if debugging then
--         print("< DKT_Core: ACTIVE >")
--     end
--     printFactions()
-- end
-- Events.EveryHours.Add(DKT_Core.OnEveryHour)

function DKT_Core.EveryTenMinutes()
    if debugging then
        print("< DKT_Core: ACTIVE >")
    end
    printFactions()
end

Events.EveryTenMinutes.Add(DKT_Core.EveryTenMinutes)

return DKT_Core