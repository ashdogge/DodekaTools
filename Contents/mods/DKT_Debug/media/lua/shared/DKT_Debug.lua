local DKT_Debug = {}

DKT_Debug.version = "0.0.10"
local DKT_Area = require("DKT_Area")

-- Options:
    --Adds extra logging to debug readout
DKT_Debug.logging = true
    --Force reinitialization 
DKT_Debug.forceInit = false

if DKT_Debug.logging then 
    local gameType = "Singleplayer"

    if isServer() then
        gameType = "Server" 
    elseif isClient() then
        gameType = "Client / Host"
    end
    
    print("DKT_Debug: Game Type [".. gameType .."], running [" .. DKT_Debug.version .."]")

end
    --Status logging
function DKT_Debug.status()
    if DKT_Debug.logging then 
        print("< DKT_Debug Logging Enabled: >")
    end
end

--Print player location readout
function DKT_Debug.findPlayerLocation(DKT_Area)
    local player = getPlayer()
    local playerX, playerY, playerZ = player:getX(), player:getY(), player:getZ()

    print("< DKT_Debug: Player found at location: X: ".. playerX .." Y: ".. playerY .." Z: ".. playerZ .." >")

    local cellX = math.floor(playerX / 150)
    local cellY = math.floor(playerY / 150)
    print("< DKT_Debug: Current Cell: ".. cellX.. "," .. cellY .. " >")

    local currentCell = DKT_Area[cellY] and DKT_Area[cellY][cellX]
    if currentCell then
        print("<< Player cell: " .. tostring(currentCell.enabled) .. " >>")
    else
        print("<< Player cell not found in DKT_Area >>")
    end
end


function DKTlog(msg)
    if DKT_Debug.logging then
        print("***<<<-- DKT_Debug -->>*** " .. msg)
    end
end

GameTime.setServerTimeShift(0)
-- < Cache the function >
local getTime = GameTime.getServerTime
local totalTime = 0
local calls = 0

function DKT_Debug.benchmark(func,...)

    local start = getTime()
    func(...)
    local deltaTime = getTime() - start

    totalTime = totalTime + deltaTime
    calls = calls + 1

end

---Print the benchmarking results in the console
function DKT_Debug.printBenchmark()
    if calls > 0 then
        local avgSeconds = totalTime / calls
        local avgMillis = avgSeconds * 1000
        print(string.format("< DKT_DEBUG > Average time: %.3f ms over %d call(s)", avgMillis, calls))
        DKT_Debug.resetBenchmark()
    else
        print("< DKT_DEBUG > Need to benchmark at least once")
    end
end

---Reset the benchmark
function DKT_Debug.resetBenchmark()
    totalTime = 0
    calls = 0
end

return DKT_Debug