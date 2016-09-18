local Ball = Base:extend({
    image   = nil,

    body    = nil,
    shape   = nil,
    fixture = nil,

    speed   = 350,
})

function Ball:constructor(x, y, speed)
    self.image = love.graphics.newImage("assets/ball.png")

    x = x or love.graphics.getWidth() / 2
    y = y or love.graphics.getHeight() / 2 - 100

    self.body = love.physics.newBody(world, x, y, "dynamic")
    self.body:setBullet(True)
    math.randomseed(os.time())
    local angle = math.rad(math.random(120, 80))
    self.body:setLinearVelocity(math.cos(angle) * self.speed,
                                math.sin(angle) * self.speed)
    self.shape = love.physics.newCircleShape(8) -- TODO: make this dynamic
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData("Ball")
    self.fixture:setRestitution(1)
    self.fixture:setFriction(0.0)

    self.speed = speed or self.speed
end

function Ball:update(dt)
end

function Ball:draw(dt)
    love.graphics.draw(self.image, self.body:getX() - (self.image:getHeight() / 2),
                       self.body:getY() - (self.image:getHeight() / 2))
end

function Ball:getAngle()
    vx, vy = self.body:getLinearVelocity()

    return math.deg(math.atan2(vy, vx))
end

function Ball:changeAngle(factor)
    local current_angle = self:getAngle()
    local new_angle = 0

    if current_angle < 0 then
        new_angle = -math.rad(-current_angle + factor)
    elseif current_angle > 0 then
        new_angle = math.rad(current_angle + factor)
    end

    --print("CUR:", current_angle, "NEW:", math.deg(new_angle), "FAC:", factor)

    self.body:setLinearVelocity(math.cos(new_angle) * self.speed,
                                math.sin(new_angle) * self.speed)
end


return Ball
