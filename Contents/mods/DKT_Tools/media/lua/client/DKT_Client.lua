local DKT_Client = DKT_Client or {}
local debugging = true

local ticks = 0

local function onInitGlobalModData()
	if not isClient() then 
        return
    end
        -- If we already have modData, remove & resync
	if ModData.exists("events") then
        print("**!@# events EXISTS")
		ModData.remove("events")
	end
     
	events = ModData.getOrCreate("events")
	ModData.request("DKT_Tools")
end

-- DKT_Tools
-- -events
-- -active_players
local function onReceiveGlobalModData(key, data)
    if key ~= "DKT_Tools" then
        return
    end
    for k, v in pairs(data.events)do 
        events[k] = v
    end
end
-- -- Credits for this function: Konijima
-- local delayFunction = function(func, delay)

--     delay = delay or 1
--     local ticks = 0
--     local canceled = false

--     local function onTick()

--         if not canceled and ticks < delay then
--             ticks = ticks + 1
--             return
--         end

--         Events.OnTick.Remove(onTick)
--         if not canceled then func() end
--     end

--     Events.OnTick.Add(onTick)
--     return function()
--         canceled = true
--     end
-- end

-- local function eventTrigger(player)
    
--     if isClient() then
--         sendClientCommand(player, "DKT_Tools", "DKTEvent", {})
--     else
--         print("Function eventTrigger fired")
--     end

-- end

-- local function onRecieveGlobalModData(id, data)
--     if id ~= "DKT_Tools.events" then
--         return 
--     end
--     if not DKT_Tools.events then
--         return
--     end

--         for key, value in pairs(data) do
--         DKT_Tools.events[key] = value
--     end
-- end

-- local function eventCheck(player)
--     if not player then
--         return
--     end
--     if not DKT_Tools.events then 
--         return 
--     end
--     print("Found DKT_Tools.events")
--     -- if getTableLength(DKT_Tools.events) == 0 then 
--     --     return 
--     -- end

--     -- local playerX, playerY, playerZ = player:getX(), player:getY(), player:getZ()

--     -- for i, event in ipairs(DKT_Tools.events) do
--     --     if playerZ == event.origin.z then
--     --         local proximity = (playerX - event.origin.x) ^2 + (playerY - event.origin.y) ^2

--     --         if proximity < (event.radius ^ 2) then
--     --             eventTrigger(player)
--     --         end 
--     --     end
--     --         print(event.test)
--     -- end

-- end

-- local function onTick()
--     local player = getPlayer();
--     if not player then 
--         return
--     end
--     if ticks < 100 then
--         ticks = ticks + 1
--     else
--         ticks = 0
--         eventCheck(player)
--     end

-- end

-- Events.OnTick.Add(onTick)

Events.OnInitGlobalModData.Add(onInitGlobalModData)
Events.OnReceiveGlobalModData.Add(onReceiveGlobalModData)