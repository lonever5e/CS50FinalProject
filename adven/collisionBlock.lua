CollisionBlock = Object:extend()

function CollisionBlock:new(x, y, height)
  self.x = x
  self.y = y
  self.width = 16
  self.height = height or 16
end

function CollisionBlock:draw()
  love.graphics.setColor(255, 0, 0, 0.5)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
  love.graphics.setColor(255, 255, 255)
end