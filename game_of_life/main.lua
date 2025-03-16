local squares = {}
local temp = {}
local sim_speed = 0.5
local sim_scale = 0.01
local next_time_step = sim_speed
local pause = true
function love.load()
	love.graphics.setColor(0, 1, 0, 1)
	drawGrid()
end

function drawGrid()
	screen_width, screen_height = love.graphics.getDimensions()
	grid_size_x = screen_width * sim_scale
	grid_size_y = screen_height * sim_scale
	total_x = math.floor(screen_width / grid_size_x)
	total_y = math.floor(screen_height / grid_size_y)

	for i = 1, total_x do
		squares[i] = {}
		for j = 1, total_y do 
			squares[i][j] = {live = 0, color = {0, 0.1, 0, 1}}
		end
	end
end

function love.update(dt)
	if love.mouse.isDown(1) then
		create(love.mouse.getPosition())
	elseif love.mouse.isDown(2) then
		destroy(love.mouse.getPosition())
	end

	if not pause then	
		next_time_step = next_time_step - dt
		if next_time_step <= 0 then
			timeStep()
		end
	end
end

function create(x, y)
	local square = getSquare(x, y)
	--print(x, y, square.x, square.y)

	if square.x > 0 and square.x <= total_x and square.y > 0 and square.y <= total_y then
		squares[square.x][square.y].live = 1 
		squares[square.x][square.y].color = {1, 0, 0, 1}
	end
end

function getSquare(x, y)
	local square_x = math.floor(x / grid_size_x) + 1
	local square_y = math.floor(y / grid_size_y) + 1
	return {x = square_x, y = square_y}
end

function destroy(x, y)
	local square = getSquare(x, y)

	if square.x > 0 and square.x < total_x and square.y > 0 and square.y < total_y then
		squares[square.x][square.y].live = 0 
		squares[square.x][square.y].color = {0, 0, 0, 1}
	end
end

function love.keypressed(key)
	if key == "space" then
		for row_index, row in ipairs(squares) do
			for col_index, col in ipairs(row) do
				col.live = 0
			end
		end
	elseif key == "p" then
		pause = not pause
	elseif key == "right" then
		sim_speed = math.max(sim_speed - 0.05, 0.05)
	elseif key == "left" then
		sim_speed = sim_speed + 0.05
	elseif key == "down" then
		sim_scale = math.max(sim_scale - 0.01, 0.01)
		drawGrid()
	elseif key == "up" then
		sim_scale = math.min(sim_scale + 0.01, 0.25)
		drawGrid()
	end
end


function timeStep()
	next_time_step = sim_speed
	temp = {}
	for row_index, row in ipairs(squares) do
		temp[row_index] = {}
		for col_index, cell in ipairs(row) do
			temp[row_index][col_index] = {}
			local col = temp[row_index][col_index]
			col.live = cell.live
			col.color = cell.color
			local live_neighbours = 0
			for x = -1, 1 do
				for y = -1, 1 do
					if x == 0 and y == 0 then
						goto continue
					end

					if squares[row_index + x] and squares[row_index + x][col_index + y] and squares[row_index + x][col_index + y].live == 1 then
						--print("row: " .. row_index, "x: " .. x, "sum: " .. row_index + x, "col: " .. col_index, "y: " .. y, "sum: " .. col_index + y)
						live_neighbours = live_neighbours + 1
					end
					::continue::
				end
			end
			if live_neighbours > 0 then
				--print(row_index, col_index, live_neighbours)
			end

			if cell.live == 1 then -- alive
				col.live = 0
				local new_col = {0, 0, 0, 1}
				if live_neighbours == 2 or live_neighbours == 3 then
					col.live = 1 -- continue living if has 2 or 3 neighbours
					new_col = cell.color
					new_col[2] = math.min(1, new_col[2] + 0.1)
				end
				col.color = new_col
			else -- dead
				if live_neighbours == 3 then
					col.live = 1 -- come alive if has 3 neighbours
					col.color = {0, 0.1, 0, 1}
				end 
			end
		end
	end
	squares = temp
end

function love.draw()
	local square = getSquare(love.mouse.getPosition())
	for row_index, row in ipairs(squares) do
		for col_index, col in ipairs(row) do
			if col.live == 1 then
				love.graphics.setColor(col.color)
				love.graphics.rectangle("fill", (row_index - 1) * grid_size_x, (col_index - 1) * grid_size_y, grid_size_x, grid_size_y)
			end
		end
	end
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.rectangle("line", (square.x - 1) * grid_size_x, (square.y - 1) * grid_size_y, grid_size_x, grid_size_y)
	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.print("speed: " .. 1/sim_speed, 10, 10)
	love.graphics.print("scale: " .. 1/sim_scale, 10, 25)
	love.graphics.print("'P' to play/pause the sim", 10, 40)
	love.graphics.print("'SPACE' to clear screen", 10, 55)
	love.graphics.print("'ARROWS' to adjust sim speed/scale", 10, 70)
end
