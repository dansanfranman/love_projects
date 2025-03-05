local Object = require("classic")
local Bullet = require("bullet")

local Player = Object.extend(Object)

function Player:new(spawnPos, image, winWidth)
	self.image = love.graphics.newImage(image)
	self.x = spawnPos
	self.y = self.image:getHeight()
	self.speed = 100
	self.maxX = winWidth - self.image:getWidth()
	self.bullets = {}
end

function Player:update(dt)
	if love.keyboard.isDown("left") then
		self.x = self.x - self.speed * dt
	elseif love.keyboard.isDown("right") then
		self.x = self.x + self.speed * dt
	end

	if self.x < 0 then
		self.x = 0
	end

	if self.x > self.maxX then
		self.x = self.maxX
	end

	for index, bullet in ipairs(self.bullets) do
		bullet:update(dt)
	end
end

function Player:draw()
	love.graphics.draw(self.image, self.x, self.y)

	for index, bullet in ipairs(self.bullets) do
		bullet:draw()
	end
end

function Player:fire()
	local bullet = Bullet(self.x + self.image:getWidth() * 0.5, self.y + self.image:getHeight(), self.speed, "img/bullet.png")
	table.insert(self.bullets, bullet)
end

return Player
