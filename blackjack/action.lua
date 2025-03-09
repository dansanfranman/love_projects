local Object = require("classic")
local Action = Object:extend()

function Action:new(action, count, delay, nextAction)
	self.action = action
	self.count = count
	self.storedDelay = delay
	self.delay = delay
	self.nextAction = nextAction
end

function Action:update(dt)
	if self.action == nil then
		return
	end

	if self.delay > 0 then
		self.delay = self.delay - dt
		return
	end

	self.delay = 0
	if self.count > 0 then
		self.count = self.count - 1
		self:action()
		self.delay = self.storedDelay
		return
	end

	if self.nextAction then
		self.action = self.nextAction.action
		self.count = self.nextAction.count
		self.storedDelay = self.nextAction.storedDelay
		self.delay = self.storedDelay
		self.nextAction = self.nextAction.nextAction
	end
end

return Action
