local Paddle = Base:extend({
    image   = nil,

    body    = nil,
    shape   = nil,
    fixture = nil,

    move    = {left = 0, right = 0, up = 0, down = 0},
    --move    = 'nowhere', -- TODO: Improve that movement system with history support

    speed   = 400,
})

function Paddle:constructor(x, y)
    self.image = love.graphics.newImage("assets/paddle.png")

    x = x or (love.graphics.getWidth() / 2)
    y = y or love.graphics.getHeight() -
            (love.graphics.getHeight() / 100 * 10)

    self.body = love.physics.newBody(world, x, y, "static")
    self.shape = love.physics.newRectangleShape(self.image:getWidth(),
                                                self.image:getHeight())
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData("Paddle")
    self.fixture:setFriction(0.0)
end

function Paddle:update(dt)
    if self.move.left > 0 and self.body:getX() - (self.image:getWidth()/2) > 0 then
        self.body:setX(self.body:getX() - (self.speed * dt))
    end
    if self.move.right > 0
        and self.body:getX() + (self.image:getWidth()/2) < love.graphics.getWidth() then
        self.body:setX(self.body:getX() + (self.speed * dt))
    end
    if self.move.up > 0 then
        self.body:setY(self.body:getY() - (self.speed * dt))
    end
    if self.move.down > 0 then
        self.body:setY(self.body:getY() + (self.speed * dt))
    end
end

function Paddle:keypressed(key, scancode, isrepeat)
    if key == 'left' then
        self.move.left = 1
    elseif key == 'right' then
        self.move.right = 1
    elseif key == 'up' then
        self.move.up = 1
    elseif key == 'down' then
        self.move.down = 1
    end
end

function Paddle:keyreleased(key)
    if key == 'left' then
        self.move.left = 0
    elseif key == 'right' then
        self.move.right = 0
    elseif key == 'up' then
        self.move.up = 0
    elseif key == 'down' then
        self.move.down = 0
    end
end

function Paddle:draw(dt)
    --love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    love.graphics.draw(self.image, self.body:getX() - (self.image:getWidth() / 2),
                       self.body:getY() - (self.image:getHeight() / 2))
    --x, y = self.fixture:getBoundingBox()
    --love.graphics.draw(self.image, x, y)
end

return Paddle
