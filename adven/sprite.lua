Sprite = Object:extend()

function Sprite:new(x, y, img, scale, frameRate, frameBuffer)
  self.scale = scale or 1
  self.x = x
  self.y = y
  self.image = love.graphics.newImage(img)
  self.width = self.image:getWidth() * self.scale
  self.height = self.image:getHeight() * self.scale
  self.frameRate = frameRate or 1
  self.frame_width = self.width / self.frameRate
  self.frame_height = self.height
  self.frames = {}
  self.currentFrame = 1
  self.frameBuffer = frameBuffer or 10
  for i=0, self.frameRate-1 do
    table.insert(self.frames, love.graphics.newQuad(i * self.frame_width, 0, self.frame_width, self.frame_height, self.width, self.height))
  end
end

function Sprite:draw()
  if self.image ~= nil then
    --love.graphics.scale(self.scale, self.scale)
    --love.graphics.translate(0, -432 + screenHeight/6)
    --love.graphics.translate(0, -self.height + screenHeight/6)
    --love.graphics.draw(self.image, self.x, self.y)
    --love.graphics.setColor(0, 255, 0, 0.2)
    love.graphics.draw(self.image, self.frames[math.floor(self.currentFrame)], self.x, self.y)
    --love.graphics.setColor(255, 255, 255, 1)
  end
end

function Sprite:update(dt)
  
  self.currentFrame = self.currentFrame + dt * self.frameBuffer
  if self.currentFrame > self.frameRate then
    self.currentFrame = 1
  end
end