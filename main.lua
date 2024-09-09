local driveImpactSound
local timeElapsed
local timeToPlay
local gamepad
local elapsedFrames
local counterInTime
local leftBumperPressed
local awaitingResponse
local frameCounter
local reactionFrames
local font

local minTime = 5
local maxTime = 60

function love.load()
    love.window.setTitle("Drive Impact Practice")
    love.window.setMode(640, 480)
    love.window.setVSync(1)
    love.graphics.setBackgroundColor(1,1,1,1)
    font = love.graphics.newFont(200)
    love.graphics.setFont(font)
    driveImpactSound = love.audio.newSource("driveImpact.mp3", "stream")
    gamepad = love.joystick.getJoysticks()[1]
    gamepads = love.joystick.getJoysticks()
    reactionFrames = 0
    frameCounter = 0
    timeElapsed = 0
    elapsedFrames = 0
    counterInTime = 0
    leftBumperPressed = false
    awaitingResponse = false
    timeToPlay = math.random(minTime, maxTime)
end

function love.update(dt)
    frameCounter = frameCounter + dt
    if frameCounter >= 0.016 then
        elapsedFrames = elapsedFrames + 1
        frameCounter = 0
    end

    timeElapsed = timeElapsed + dt
    if timeElapsed >= timeToPlay then
        driveImpactSound:play()
        timeToPlay = math.random(minTime, maxTime)
        timeElapsed = 0
        elapsedFrames = 0
        awaitingResponse = true
    end

    for i,pad in ipairs(gamepads) do
        if pad:isGamepad() and pad:isGamepadDown("leftshoulder") then
            handleBumperPress()
        else
            leftBumperPressed = false
        end
    end

end

function handleBumperPress()
    if leftBumperPressed then
        return 
    end

    if awaitingResponse then
        counterInTime = elapsedFrames <= 26
        awaitingResponse = false
        leftBumperPressed = true
        reactionFrames = elapsedFrames
    end
end

function love.draw()
    if leftBumperPressed then
        love.graphics.clear({1, 1, 1, 1})
    elseif counterInTime then
        love.graphics.clear({0, 1, 0, 1})
    else
        love.graphics.clear({1, 0, 0, 1})
    end

    local text = tostring(reactionFrames)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local textWidth = font:getWidth(text)
    local textHeight = font:getHeight(text)
    local x = (screenWidth - textWidth) / 2
    local y = (screenHeight - textHeight) / 2
    love.graphics.print(text, x, y)
end

