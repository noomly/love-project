local Brick = Base:extend({
    image   = nil,

    body    = nil,
    shape   = nil,
    fixture = nil,
})


function Brick:constructor(x, y)
    self.image = love.graphics.newImage("assets/brick.png")

    self.body = love.physics.newBody(world, x, y, "static")
    self.shape = love.physics.newRectangleShape(self.image:getWidth(),
                                                self.image:getHeight())
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setFriction(0.0)
    self.fixture:setUserData("Brick")
    print(self.fixture:getBoundingBox())
    print(self.body:getX(), self.body:getY())
end

function Brick:draw(dt)
    if not self.fixture:isDestroyed() then
        --love.graphics.draw(self.image, self.body:getX() - (self.image:getHeight() / 2),
        --                   self.body:getY() - (self.image:getHeight() / 2))

        x, y = self.fixture:getBoundingBox()
        love.graphics.draw(self.image, x, y)

        --love.graphics.rectangle('fill', self.body:getX(), self.body:getY(),
        --self.image:getWidth(), self.image:getHeight())
    end
end

return Brick
