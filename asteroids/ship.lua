local Object = require("classic")
local Ship = Object:extend()

local bullets = {}

function Ship:new()
	self.x = love.graphics.getWidth() * 0.5
	self.y = love.graphics.getHeight() * 0.5
	self.shape = {5,2, 0,0, 5,10, 10,0}
	self.scale = 2.5
	self.rotation = math.pi
	self.velocity = 0
	self.speed = 20
	self.turnSpeed = 10

	for i = 1, #self.shape do
		self.shape[i] = self.shape[i] * self.scale
	end
	local geo_x = 0
	local geo_y = 0
	local point_count = 0

	self.tris = love.math.triangulate(self.shape)
	for i, tri in ipairs(self.tris) do
		geo_x = geo_x + tri[1] + tri[3] + tri[5]
		geo_y = geo_y + tri[2] + tri[4] + tri[6]
		point_count = point_count + 3
	end	

	self.geoCenter = {x = geo_x / point_count, y = geo_y / point_count}

end
	
function Ship:update(dt)
	if love.keyboard.isDown("s") then
		self.velocity = self.velocity + self.speed * dt
	elseif love.keyboard.isDown("w") then
		self.velocity = self.velocity - self.speed * dt
	end

	if love.keyboard.isDown("a") then
		self.rotation = self.rotation - self.turnSpeed * dt
	elseif love.keyboard.isDown("d") then
		self.rotation = self.rotation + self.turnSpeed * dt
	end

	local moveX = math.cos(self.rotation - math.pi * 0.5) * self.velocity
	local moveY = math.sin(self.rotation - math.pi * 0.5) * self.velocity

	self.x = self.x + moveX
	self.y = self.y + moveY

	if self.velocity > 0 then
		self.velocity = math.max(0, self.velocity - dt)
		self.velocity = math.min(self.velocity, 5)
	else
		self.velocity = math.min(0, self.velocity + dt)
		self.velocity = math.max(self.velocity, -5)
	end

	self.x = self.x + dt
	self.y = self.y + dt

	return moveX, moveY
end

function Ship:draw()
	love.graphics.push()
		love.graphics.translate(self.x, self.y)
		love.graphics.rotate(self.rotation)
		love.graphics.translate(-self.geoCenter.x, -self.geoCenter.y)

		for i, triangle in ipairs(self.tris) do
			love.graphics.polygon("line", triangle)
		end
		love.graphics.circle("fill", self.geoCenter.x, self.geoCenter.y, 5, 5)
	love.graphics.pop()
end
return Ship
