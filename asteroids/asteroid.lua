local Object = require("classic")
local Asteroid = Object:extend()

function Asteroid:new()
end

local function generateAsteroidPolygon(minRadius, maxRadius, numPoints, randomSeed)
    -- Set a random seed if provided, otherwise use system time
    if randomSeed then
        love.math.setRandomSeed(randomSeed)
    end

    -- Create the asteroid polygon points
    local points = {}
    local angleStep = (2 * math.pi) / numPoints

    for i = 1, numPoints do
        -- Calculate base angle
        local angle = (i - 1) * angleStep

        -- Random radius variation to create irregular shape
        local radiusVariation = love.math.random() * (maxRadius - minRadius) + minRadius
        
        -- Add some additional randomness to make the shape more irregular
        local irregularityFactor = love.math.random() * 0.4 + 0.8  -- Between 0.8 and 1.2
        local radius = radiusVariation * irregularityFactor

        -- Calculate x and y coordinates
        local x = math.cos(angle) * radius
        local y = math.sin(angle) * radius

        table.insert(points, x)
        table.insert(points, y)
    end

    return points
end

-- Function to create multiple asteroid variations
local function createAsteroidVariations(count, minRadius, maxRadius, numPoints)
    local asteroids = {}
    
    for i = 1, count do
        -- Use different random seeds for each asteroid
        local asteroid = generateAsteroidPolygon(minRadius, maxRadius, numPoints, i * 1000)
        table.insert(asteroids, asteroid)
    end
    
    return asteroids
end

function Asteroid:load()
    asteroidShapes = createAsteroidVariations(5, 20, 40, 8)
end

function Asteroid:draw()
    for i, asteroid in ipairs(asteroidShapes) do
        love.graphics.push()
        love.graphics.translate(100 + i * 100, 200)  -- Spread out asteroids
        love.graphics.polygon('line', asteroid)
        love.graphics.pop()
    end
end

return Asteroid
