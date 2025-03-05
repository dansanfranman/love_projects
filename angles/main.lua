io.stdout:setvbuf("no")

function love.load()
	circle = {}
	circle.x = 100
	circle.y = 100
	circle.radius = 25
	circle.speed = 200

	arrow = {}
	arrow.x = 200
	arrow.y = 200
	arrow.speed = 300
	arrow.angle = 0
	arrow.image = love.graphics.newImage("arrow_right.png")
	arrow.origin_x = arrow.image:getWidth() * 0.5
	arrow.origin_y =arrow.image:getHeight() * 0.5
end

function love.update(dt)
	mouse_x, mouse_y = love.mouse.getPosition()
	angle = math.atan2(mouse_y - circle.y, mouse_x - circle.x)
	arrow.angle = angle

	cos = math.cos(angle)
	sin = math.sin(angle)

	circle.x = circle.x + circle.speed * cos * dt
	circle.y = circle.y + circle.speed * sin * dt

	arrow.x = arrow.x + arrow.speed * cos * dt
	arrow.y = arrow.y + arrow.speed * sin * dt
end

function love.draw()
	love.graphics.circle("line", circle.x, circle.y, circle.radius)
	love.graphics.line(circle.x, circle.y, mouse_x, mouse_y)
	love.graphics.line(circle.x, circle.y, mouse_x, circle.y)
	love.graphics.line(mouse_x, mouse_y, mouse_x, circle.y)

	love.graphics.draw(arrow.image, arrow.x, arrow.y, arrow.angle, 1, 1, arrow.origin_x, arrow.origin_y)
	love.graphics.circle("fill", mouse_x, mouse_y, 5)
end

function getDistanceSqr(x1, y1, x2, y2)
	local horiz_dist = x1 - x2
	local vert_dist = y1 - y2

	local a = horiz_dist * horiz_dist
	local b = vert_dist ^ 2

	local c = a + b
	return c
end
