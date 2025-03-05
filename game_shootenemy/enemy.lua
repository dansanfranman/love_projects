local Object = require("classic")
local Enemy = Object.extend(Object)

function Enemy:new(image, winWidth, winHeight)
	self.image = love.graphics.newImage(image)
	self.direction = -1
	self.x = 0
	self.speed = 100
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()
	self.maxX = winWidth - self.width
	self.y = winHeight - self.height
end

function Enemy:update(dt)
	self.x = self.x + self.direction * self.speed * dt
	if self.x < 0 or self.x > self.maxX then
		self.direction = self.direction * -1
	end
end

function Enemy:draw()
	love.graphics.draw(self.image, self.x, self.y)
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

function Enemy:checkCollisions(bullets)
	for index, bullet in ipairs(bullets) do
		if self:checkCollision(bullet) then
			self.speed = self.speed + 25
			return
		end
	end
end

function Enemy:checkCollision(bullet)
	local bulletShape = bullet:getCollisionShape() -- x, y, width, height

	local bullet_x_min = bulletShape.x
	local bullet_x_max = bulletShape.x + bulletShape.width
	local bullet_y_min = bulletShape.y
	local bullet_y_max = bulletShape.y + bulletShape.height

	local self_x_min = self.x
	local self_x_max = self.x + self.width
	local self_y_min = self.y
	local self_y_max = self.y + self.height

	return bullet_x_min < self_x_max
	and bullet_x_max > self_x_min
	and bullet_y_min < self_y_max
	and bullet_y_max > self_y_min
end

return Enemy
