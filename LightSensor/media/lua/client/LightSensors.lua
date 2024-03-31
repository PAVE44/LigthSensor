local TAAddLightSensor = require("Actions/TAAddLightSensor")
local TARemoveLightSensor = require("Actions/TARemoveLightSensor")

function TimedAddLightSensor (player, square, object, sensor)
    if luautils.walkAdj(player, square) then
        ISTimedActionQueue.add(TAAddLightSensor:new(player, square, object, sensor))
    end
end

function TimedRemoveLightSensor (player, square, object)
    if luautils.walkAdj(player, square) then
        ISTimedActionQueue.add(TARemoveLightSensor:new(player, square, object))
    end
end

function LSEveryOneMinute()
    local world = getWorld()
    local cm = world:getClimateManager()
    local dls = cm:getDayLightStrength()
    local cell = getCell()

    local globalModData = GetLightSensorsModData()
    for k, vsensor in pairs(globalModData.LightSensors) do
        local x, y, z = Id2Coords(k)
        local square = cell:getGridSquare(x, y, z)
        if square then
            local lightSwitch = GetLightSwitch(square)
            if lightSwitch then
                if vsensor.s > dls then
                    -- should be on 
                    print ("ON BECAUSE: SENSOR.S: " .. vsensor.s .. " > DLS: " .. dls)
                    lightSwitch:setActive(true)
                else
                    print ("OFF BECAUSE: SENSOR.S: " .. vsensor.s .. " < DLS: " .. dls)
                    -- should be off
                    lightSwitch:setActive(false)
                end
            end
        end
    end

end

function LSWorldContextMenuPre(playerID, context, worldobjects, test)

    local square = clickedSquare
    local player = getSpecificPlayer(playerID)
   
    for _, object in pairs(worldobjects) do
        if instanceof(object, 'IsoLightSwitch') then
            print ("found ls")

            if HasSensor(object) then
                -- REMOVE SENSOR
                context:addOption("Remove Light Sensor", player, TimedRemoveLightSensor, square, object)
            else
                -- ADD SENSOR
                local sensor = player:getInventory():getFirstTypeRecurse("LSLightSensor")
                local optionAddSensor = context:addOption("Add Light Sensor", player, TimedAddLightSensor, square, object, sensor)
                if not sensor then    
                    local tooltipAddSensor = ISToolTip:new()
                    tooltipAddSensor.description = "Light sensor needed"
                    optionAddSensor.notAvailable = true
                    optionAddSensor.toolTip = tooltipAddSensor
                end
            end
        end
    end



end

Events.OnPreFillWorldObjectContextMenu.Add(LSWorldContextMenuPre)
Events.EveryOneMinute.Add(LSEveryOneMinute)
