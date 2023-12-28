CoinBlock = Object:extend()

function CoinBlock:new(x, y)
  self.x = x
  self.y = y
  self.frameRate = 15
  self.image = love.graphics.newImage("adven/src/tiled/assets/coin.png")
  self.width = self.image:getWidth()
  self.height = self.image:getHeight()
  self.frame_width = self.width / self.frameRate
  self.frame_height = self.height
  self.currentFrame = 1
  self.frames = {}
  for i=0, self.frameRate-1 do
      table.insert(self.frames, love.graphics.newQuad(i * self.frame_width, 0, self.frame_width, self.frame_height, self.width, self.height))
    end
end

function CoinBlock:update(dt)
  self.currentFrame = self.currentFrame + dt * 10
  if self.currentFrame > self.frameRate then
    self.currentFrame = 1
  end
end

function CoinBlock:draw()
  love.graphics.draw(self.image, self.frames[math.floor(self.currentFrame)], self.x, self.y)
end