Base   = require('knife.base')

Paddle = require('paddle')
Ball   = require('ball')
Brick  = require('brick')

local max_fps = 60
local min_dt = 1 / max_fps
local next_time

world = nil

local walls
local bricks
local paddle
local ball

local function makeWall(x, y, width, height)
    walls = walls or {}

    local wall = {
        body    = love.physics.newBody(world, x, y, "static"),
        shape   = love.physics.newRectangleShape(width, height),
        fixture = nil,
    }
    wall.fixture = love.physics.newFixture(wall.body, wall.shape)
    wall.fixture:setFriction(0.0)

    table.insert(walls, wall)
end

local function makeBricks()
    bricks = bricks or {}

    for x=1, 10, 1 do
        local brick = Brick(x*57, 100)

        table.insert(bricks, brick)
    end
end

function love.load(arg)
    next_time = love.timer.getTime()

    world = love.physics.newWorld(0, 0, true)
    world:setCallbacks(beginContact, endContact, _, postSolve)

    makeWall(love.graphics.getWidth()/2, 0, love.graphics.getWidth(), 10)
    makeWall(0, love.graphics.getHeight()/2, 10, love.graphics.getHeight())
    makeWall(love.graphics.getWidth(), love.graphics.getHeight()/2, 10,
             love.graphics.getHeight())
    makeWall(love.graphics.getWidth()/2, love.graphics.getHeight(),
             love.graphics.getWidth(), 10)

    makeBricks()

    paddle = Paddle()
    ball = Ball()
end

function love.update(dt)
    --print("FPS: ", love.timer.getFPS())
    next_time = next_time + min_dt

    if love.keyboard.isDown('escape') then
        love.event.push('quit')
    end

    world:update(dt)
    paddle:update(dt)
    ball:update(dt)
    --print(ball.body:getLinearVelocity())
end

function beginContact(a, b, coll)
    local brick_f = nil
    local paddle_f = nil

    local ball_f = nil

    if a:getUserData() == "Brick" then
        brick_f = a
    elseif a:getUserData() == "Paddle" then
        paddle_f = a
    end

    if b:getUserData() == "Ball" then
        ball_f = b
    end

    if brick_f then brick_f:destroy() end

    if paddle_f then
        local padcol = (paddle.body:getLocalPoint(coll:getPositions()) +
                        paddle.image:getWidth() / 2) / paddle.image:getWidth() * 100
        --print("PADCOL:", padcol, "WIDTH:", paddle.image:getWidth())

        if padcol < 15 then
            ball:changeAngle(35)
        elseif padcol < 40 then
            ball:changeAngle(15)
        elseif padcol > 85 then
            ball:changeAngle(-35)
        elseif padcol > 60 then
            ball:changeAngle(-15)
        end
    end
end

function endContact(a, b, coll)
end

function postSolve(a, b, coll)
end

function love.keypressed(key, scancode, isrepeat)
    paddle:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode, isrepeat)
    paddle:keyreleased(key)
end

function love.draw(dt)
    paddle:draw(dt)
    ball:draw(dt)

    for _, brick in ipairs(bricks) do
        brick:draw(dt)
    end

    local cur_time = love.timer.getTime()
    if next_time <= cur_time then
        next_time = cur_time
        return
    end
    love.timer.sleep(next_time - cur_time)
end

