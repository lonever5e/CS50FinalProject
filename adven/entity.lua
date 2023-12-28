Entity = Object:extend()

function Entity:new(x, y, img, frameRate)
  self.x = x
  self.y = y
  self.image = love.graphics.newImage(img)
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
  self.frameRate = frameRate
  self.frame_width = self.width / self.frameRate
  self.frame_height = self.height
  self.frames = {}
  self.currentFrame = 1
  self.frameBuffer = 10
  for i=0,7 do
    table.insert(self.frames, love.graphics.newQuad(i * self.frame_width, 0, self.frame_width, self.frame_height, self.width, self.height))
  end
end

function Entity:update(dt)
  self.currentFrame = self.currentFrame + dt * self.frameBuffer
  if self.currentFrame > 6 then
    self.currentFrame = 1
  end
end

function Entity:draw()
  if self.image ~= nil then
    --love.graphics.draw(self.image, self.x, self.y)
    love.graphics.draw(self.image, self.frames[math.floor(self.currentFrame)], self.x, self.y)
    love.graphics.setColor(0, 255, 0, 0.2)
    love.graphics.rectangle("fill", self.x, self.y, self.frame_width, self.frame_height)
    love.graphics.setColor(255, 255, 255, 1)
  end
end