io.stdout:setvbuf("no")

function love.load()

end

function love.update(dt)

end

function love.draw()
    love.graphics.print("Hello World!", 100, 100)
end

print("Console output is working as intended!")
