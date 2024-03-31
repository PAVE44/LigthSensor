function Coords2Id (x, y, z)
    local id = x .. "-" .. y .. "-" .. z
    return id
end

function Id2Coords (inputstr)

    local t = {}
    for str in string.gmatch(inputstr, "([^-]+)") do
            table.insert(t, str)
    end
    return tonumber(t[1]), tonumber(t[2]), tonumber(t[3])
end

function HasSensor (object)
    local x = object:getX()
    local y = object:getY()
    local z = object:getZ()
    local k = Coords2Id(x, y, z)

    local globalModData = GetLightSensorsModData()
    if globalModData.LightSensors[k] then
        return true
    else
        return false
    end
end

function GetLightSwitch(square)
    local objects = square:getObjects()
    for i=0, objects:size()-1 do
        local object = objects:get(i)
        if instanceof(object, 'IsoLightSwitch') then
            return object
        end
    end
    return nil
end