io.stdout:setvbuf("no")
print(123)

function love.draw()
    love.graphics.print("Hello World", 100, 100)
end
