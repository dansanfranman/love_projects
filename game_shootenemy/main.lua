io.stdout:setvbuf("no")
local Player = require("player")
local Enemy = require("enemy")
local player, enemy

function love.load()
	local width, height = love.graphics.getDimensions()
	player = Player(500, "img/panda.png", width)
	enemy = Enemy("img/snake.png", width, height)
end

function love.update(dt)
	player:update(dt)
	enemy:update(dt)
	enemy:checkCollisions(player.bullets)
end

function love.keypressed(key)
	if key == "space" then
		player:fire()
	end
end

function love.draw()
	player:draw()
	enemy:draw()
end
