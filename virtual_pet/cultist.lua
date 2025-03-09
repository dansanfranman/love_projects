local Object = require("classic")
local Cultist = Object.extend(Object)

local cultist_states = {
	idle = "idle",
	walk = "walk",
	jump = "jump",
	die = "die"
	}

local state = {}
local xBounds, yBounds

function Cultist:new(xBound, yBound)
	self.x = 100
	self.y = 100
	xBounds = xBound
	yBounds = yBound

	self.state = {}
	self:setupStates()	

	-- idle is default state
		self.currentFrame = 1
		self.currentState = cultist_states.idle
		self.currentAnimationFrameCount = self.idleFrameCount
	--
end

function Cultist:setupStates()
	self:setupIdle()
	self:setupWalk()
	self:setupJump()
	self:setupDie()
end

function Cultist:setupIdle(xBound, yBound)
	self.idleSpriteSheet = love.graphics.newImage("img/cultist/cultist_idle.png")
	self.idleFrames = {}
	self.idleWidth = self.idleSpriteSheet:getWidth()
	self.idleHeight = self.idleSpriteSheet:getHeight()
	self.idleFrameCount = 4

	local frameWidth = self.idleWidth / self.idleFrameCount
	local frameHeight = self.idleHeight

	for i = 1, self.idleFrameCount do
		table.insert(self.idleFrames, love.graphics.newQuad(i * frameWidth, 0, frameWidth, frameHeight, 
					self.idleWidth, self.idleHeight))
	end

	table.insert(state, cultist_states.idle)
end

function Cultist:setupWalk()
	table.insert(state, cultist_states.walk)
end

function Cultist:setupJump()
	table.insert(state, cultist_states.jump)
end

function Cultist:setupDie()
	table.insert(state, cultist_states.die)
end

function Cultist:update(dt)
	self.currentFrame = self.currentFrame + 2 * dt

	if self.currentFrame > self.currentAnimationFrameCount then
		self:nextState()
		self.currentFrame = 1
	end

	if self.currentState == cultist_states.walk then
		self.x = self.x + love.math.random(-100, 100) * dt
		self.y = self.y + love.math.random(-100, 100) * dt

		if self.x < 0 then
			self.x = 0
		end

		if self.y < 0 then
			self.y = 0
		end

		if self.x > xBounds then
			self.x = xBounds
		end

		if self.y > yBounds then 
			self.y = yBounds
		end
	end
		
end

function Cultist:draw()
	love.graphics.push()
		love.graphics.draw(self.idleSpriteSheet, self.idleFrames[math.floor(self.currentFrame)], self.x, self.y)
	love.graphics.pop()
end

function Cultist:nextState()
	if self.currentState == cultist_states.idle then
		local next_state = love.math.random(1, 4)
		self.currentState = state[next_state] 
	else
		self.currentState = cultist_states.idle
	end

--	self.currentState = cultist_states.walk
	self.currentFrame = 1
end
		

return Cultist
