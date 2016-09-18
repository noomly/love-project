local Base = require 'knife.base'

local Mob = Base:extend({
    name = "defaultName",
    speed = 0,
    size = 5
})

function Mob:constructor(name, speed, size)
    self.name = name
    self.speed = speed
    self.size = size

    print("A Mob called " .. self.name .. " was just created")
end

function Mob:move(steps)
    print("Mob " .. self.name .. " make " .. tostring(steps) .. " steps forward")
end

local Car = Mob:extend({
    name = "defaultCarName",
})

function Car:vroom()
    self:move(self.speed)
    print("VROOOM")
end


local mycar = Car()
mycar:vroom()

