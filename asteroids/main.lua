local Ship = require("ship")
local Asteroid = require("asteroid")
local player
io.stdout:setvbuf("no")

local bullets = {}
local fire_cooldown = 0

function love.load()
	player = Ship()
	asteroid = Asteroid(0, 0, 0, 0)
	asteroid:load()
end

function love.update(dt)
	local moveX, moveY = player:update(dt)

	if love.keyboard.isDown("space") and fire_cooldown <= 0 then
		fire(moveX, moveY)
	end
	
	for i, bullet in ipairs(bullets) do
		bullet.x = bullet.x + bullet.velocity.x - math.cos(bullet.dir - 0.5 * math.pi) * 100 * dt 
		bullet.y = bullet.y + bullet.velocity.y - math.sin(bullet.dir -0.5 * math.pi) * 100 * dt
	end

	fire_cooldown = fire_cooldown - dt

	if #bullets > 5 then
		table.remove(bullets, 1)
	end
end

function fire(moveX, moveY)
	fire_cooldown = 0.5
	table.insert(bullets, {x = player.x, y = player.y, dir = player.rotation, velocity = {x = moveX, y = moveY}})
end

function love.draw()
	player:draw()

	for i, bullet in ipairs(bullets) do
		love.graphics.push()
		love.graphics.translate(bullet.x, bullet.y)
		love.graphics.rotate(bullet.dir)
		love.graphics.line(0, 10, 0, -5)
		love.graphics.pop()
	end

	asteroid:draw()
end
