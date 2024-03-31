require "ls_gmd"
require "ls_utils"

LSServer = {}
LSServer.Commands = {}

LSServer.Commands.AddLightSensor = function(player, args)
    local globalModData = GetLightSensorsModData()
    local k = Coords2Id(args.x, args.y, args.z)
    globalModData.LightSensors[k] = args
end

LSServer.Commands.RemoveLightSensor = function(player, args)
    local globalModData = GetLightSensorsModData()
    local k = Coords2Id(args.x, args.y, args.z)
    globalModData.LightSensors[k] = nil
end

-- main
local onLightSensorsClientCommand = function(module, command, player, args)
    if LSServer[module] and LSServer[module][command] then
        local argStr = ""
        for k, v in pairs(args) do
            argStr = argStr .. " " .. k .. "=" .. tostring(v)
        end
        print ("received " .. module .. "." .. command .. " "  .. argStr)
        LSServer[module][command](player, args)
        TransmitLightSensorsModData()
    end
end

print ("-------------------------------")
print ("- light sensors server ready  -")
print ("-------------------------------")

Events.OnClientCommand.Add(onLightSensorsClientCommand)
