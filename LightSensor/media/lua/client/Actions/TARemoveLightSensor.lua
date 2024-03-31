require "TimedActions/ISBaseTimedAction"

TARemoveLightSensor = ISBaseTimedAction:derive("TARemoveLightSensor");

function TARemoveLightSensor:isValid()
	return true
end

function TARemoveLightSensor:update()
end

function TARemoveLightSensor:start()
    -- self.character:setMetabolicTarget(Metabolics.DiggingSpade);
	self:setActionAnim("Loot")
	self:setOverrideHandModels(nil, nil)
	self.sound = self.character:playSound("GeneratorRepair")
end

function TARemoveLightSensor:stop()
	ISBaseTimedAction.stop(self)
end

function TARemoveLightSensor:perform()
    self.character:stopOrTriggerSound(self.sound)
    
	local x = self.object:getX()
    local y = self.object:getY()
    local z = self.object:getZ()

    local entry = {}
    entry.x = x
    entry.y = y
    entry.z = z
	entry.s = 50

    sendClientCommand(self.character, 'Commands', 'RemoveLightSensor', entry)

	local sensor = InventoryItemFactory.CreateItem("LightSensors.LSLightSensor")
	self.character:getInventory():AddItem(sensor)

	ISBaseTimedAction.perform(self)
end

function TARemoveLightSensor:new(character, square, object)
	local o = {}
	setmetatable(o, self)
	self.__index = self
    
    o.character = character
    o.square = square
	o.object = object

	o.stopOnWalk = false
    o.maxTime = 100
    o.caloriesModifier = 6
	return o
end

return TARemoveLightSensor;
