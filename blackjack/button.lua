local Object = require("classic")
local Button = Object.extend(Object)

function Button:new(x, y, width, height, text, color, textColor)
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.text = text
	self.color = color
	self.textColor = textColor	
end

function Button:checkCollision(x, y)
	return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
end

function Button:draw()
	love.graphics.setColor(self.color.r, self.color.g, self.color.b)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	love.graphics.setColor(self.textColor.r, self.textColor.g, self.textColor.b)
	love.graphics.print(self.text, self.x + self.width * 0.5, self.y + self.height * 0.5)
	love.graphics.setColor(1, 1, 1)
end

return Button
