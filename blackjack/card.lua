local Object = require("classic")
local Card = Object.extend(Object)

local cardScale = 0.15

function Card:new(value, suit, back, front)
	self.value = value
	self.suit = suit
	self.back = back
	self.front = love.graphics.newImage(front)
	self.currentImage = self.back
	self.originX = self.currentImage:getWidth() * 0.5
	self.originY = self.currentImage:getHeight() * 0.5
	self.flipDirection = 1
	self.flipScale = -1
	self.flipSpeed = 10
	self.isFlipping = false
	self.flipped = false
end

function Card:print()
	print(self.value .. " of " .. self.suit .. ", at pos: (" .. self.x .. ", " .. self.y .. ")")
end

function Card:update(dt)
	if self.isFlipping then
		self.flipScale = self.flipScale + dt * self.flipDirection * self.flipSpeed
		if not self.flipped and self.flipDirection * self.flipScale >= 0 then
			self:flip()
		end

		if math.abs(self.flipScale) > math.abs(self.flipDirection) then
			self.flipScale = self.flipDirection
			self.flipDirection = self.flipDirection * -1
			self.isFlipping = false
			self.flipped = false
		end
	end
end

function Card:getValue(score)
	if self.value == 1 and score <= 10 then
		return 11
	else
		return self.value
	end
end

function Card:moveToPosition(position)
	self.x = position.x
	self.y = position.y
end

function Card:startFlip()
	self.isFlipping = true
end

function Card:faceUp()
	self.flipDirection = 1
	self:startFlip()
end

function Card:faceDown()
	self.flipDirection = -1
	self:startFlip()
end

function Card:flip()
	if self.flipDirection == -1 then
		self.currentImage = self.back
	else
		self.currentImage = self.front
	end
	self.flipped = true
	self.originX = self.currentImage:getWidth() * 0.5
	self.originY = self.currentImage:getHeight() * 0.5
end

function Card:draw()
	love.graphics.draw(self.currentImage, self.x, self.y, 0, self.flipScale * cardScale, cardScale, self.originX, self.originY)
end

return Card
