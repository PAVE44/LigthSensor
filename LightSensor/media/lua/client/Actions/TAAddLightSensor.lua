require "TimedActions/ISBaseTimedAction"

TAAddLightSensor = ISBaseTimedAction:derive("TAAddLightSensor");

function TAAddLightSensor:isValid()
	return true
end

function TAAddLightSensor:update()
end

function TAAddLightSensor:start()
    -- self.character:setMetabolicTarget(Metabolics.DiggingSpade);
	self:setActionAnim("Loot")
	self:setOverrideHandModels(nil, nil)
	self.sound = self.character:playSound("GeneratorRepair")
end

function TAAddLightSensor:stop()
	ISBaseTimedAction.stop(self)
end

function TAAddLightSensor:perform()
    self.character:stopOrTriggerSound(self.sound)
    
	local x = self.object:getX()
    local y = self.object:getY()
    local z = self.object:getZ()

    local entry = {}
    entry.x = x
    entry.y = y
    entry.z = z
	entry.s = 0.6 + ZombRandFloat(0, 0.05)

    sendClientCommand(self.character, 'Commands', 'AddLightSensor', entry)

	self.character:getInventory():Remove(self.sensor)

	ISBaseTimedAction.perform(self)
end

function TAAddLightSensor:new(character, square, object, sensor)
	local o = {}
	setmetatable(o, self)
	self.__index = self
    
    o.character = character
    o.square = square
	o.object = object
	o.sensor = sensor

	o.stopOnWalk = false
    o.maxTime = 100
    o.caloriesModifier = 6
	return o
end

return TAAddLightSensor;
