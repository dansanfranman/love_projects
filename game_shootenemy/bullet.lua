local Object = require("classic")
local Bullet = Object.extend(Object)

function Bullet:new(x, y, speed, image)
	self.image = love.graphics.newImage(image)
	self.x = x
	self.y = y
	self.speed = speed
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()

	self.collisionShape = {
		width = self.width,
		height = self.height
	}
end

function Bullet:update(dt)
	self.y = self.y + self.speed * dt
end

function Bullet:draw()
	love.graphics.draw(self.image, self.x, self.y)
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

function Bullet:getCollisionShape()
	self.collisionShape["x"] = self.x
	self.collisionShape["y"] = self.y
	return self.collisionShape
end

return Bullet
