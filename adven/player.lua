Player = Sprite:extend()
--Player = Entity:extend()

function Player:new(x, y, img, collisionBlocks, PlatformCollisionBlocks,coinCollisionBlocks, animations)
  --Player.super.new(self, x, y, img, 8)
  
  Player.super.new(self, x, y, img, 0.5, 8)
  self.velocity = {x=0, y=0}
  self.collisionBlocks = collisionBlocks
  self.PlatformCollisionBlocks = PlatformCollisionBlocks
  self.coinCollisionBlocks = coinCollisionBlocks
  self.hitBox = {
    x = self.x + 32,
    y = self.y + 25,
    width = 18,
    height = 28
  }
  self.animations = animations
  self.lastDirection = "right"
  
  self.cameraBox = {x = self.x - 50, y = self.y, width = 200, height = 80}

  for i,v in pairs(self.animations) do
    v.image = love.graphics.newImage(v.imgSrc)
  end
end

function Player:switchSprite(key)
  if self.image ~= self.animations[key].image then
    self.image = self.animations[key].image
    self.width = self.image:getWidth() * self.scale
    self.height = self.image:getHeight() * self.scale
    self.frameRate = self.animations[key].frameRate
    self.frameBuffer = self.animations[key].frameBuffer
    self.frame_width = self.width / self.frameRate
    self.frame_height = self.height
    for k in pairs(self.frames) do
      self.frames[k] = nil
    end
    for i=0, self.frameRate-1 do
      table.insert(self.frames, love.graphics.newQuad(i * self.frame_width, 0, self.frame_width, self.frame_height, self.width, self.height))
    end
    self.currentFrame = 1
  end
end

function Player:update(dt) 
    self:checkHorizontalCanvasCollision()
    self:checkVerticalCanvasCollision()
    self.x = self.x + self.velocity.x
    self.super.update(self, dt)
    self:updateHitBox()
    self:updateCameraBox()
    self:checkHorizontalCollision()
    self:applyGravity()
    self:updateHitBox()
    self:checkVerticalCollision()
end

function Player:draw()
  self.super.draw(self)
  --love.graphics.setColor(0, 255, 0, 0.2)
  --love.graphics.rectangle("fill", self.hitBox.x, self.hitBox.y, self.hitBox.width, self.hitBox.height)
  --love.graphics.setColor(255, 255, 255, 1)
  --love.graphics.setColor(0, 0, 255, 0.3)
  --love.graphics.rectangle("fill", self.cameraBox.x, self.cameraBox.y, self.cameraBox.width, self.cameraBox.height)
  --love.graphics.setColor(255, 255, 255, 1)
end

function Player:updateHitBox()
  self.hitBox = {
    x = self.x + 32,
    y = self.y + 25,
    width = 18,
    height = 28
  }
end

function Player:updateCameraBox()
  self.cameraBox = {
    x = self.x - 50,
    y=self.y,
    width = 200,
    height = 80
  }
end

function Player:panCameraLeft()
  local camRight = self.cameraBox.x + self.cameraBox.width
  local scaledCanvasWidth = screenWidth / 6
  if (camRight < background.width) then
    if (camRight >= scaledCanvasWidth + math.abs(camera.x)) then
      camera.x = camera.x - self.velocity.x
    end
  end
end

function Player:panCameraRight()
  if self.cameraBox.x > 0 then
    if self.cameraBox.x <= math.abs(camera.x) then
      camera.x = camera.x - self.velocity.x
    end
  end
end

function Player:panCameraDown()
  if self.cameraBox.y + self.velocity.y > 0 then
    if self.cameraBox.y <= math.abs(camera.y) then
      camera.y = camera.y - self.velocity.y
    end
  end
end

function Player:panCameraUp()
  if self.cameraBox.y + self.cameraBox.height + self.velocity.y < 432 then
    local scaledCanvasHeight = screenHeight / 6
    if self.cameraBox.y + self.cameraBox.height >= math.abs(camera.y) + scaledCanvasHeight then
      camera.y = camera.y - self.velocity.y
    end
  end
end

function Player:checkHorizontalCollision()
  for i=1, #self.collisionBlocks do
    local collisionBlock = self.collisionBlocks[i]
    if collision(self.hitBox, collisionBlock) then
      if self.velocity.x > 0 then
        self.velocity.x = 0
        local offset = self.hitBox.x - self.x + self.hitBox.width
        self.x = collisionBlock.x - offset - 0.01
        break
      end
      if self.velocity.x < 0 then
        self.velocity.x = 0
        local offset = self.hitBox.x - self.x
        self.x = collisionBlock.x + collisionBlock.width - offset + 0.01
        break
      end
    end
  end
end

function Player:checkHorizontalCanvasCollision()
  if (self.hitBox.x + self.hitBox.width + self.velocity.x >= background.width
      or self.hitBox.x + self.velocity.x <=0) then
      self.velocity.x = 0
  end
end

function Player:checkVerticalCanvasCollision()
  if (self.hitBox.y + self.velocity.y <= 0) then
    self.velocity.y = 0
  end
end

function Player:applyGravity()
  self.velocity.y = self.velocity.y + gravity
  self.y = self.y + self.velocity.y
end

function Player:checkVerticalCollision()
  for i=1, #self.collisionBlocks do
    local collisionBlock = self.collisionBlocks[i]
    if collision(self.hitBox, collisionBlock) then
      if self.velocity.y > 0 then
        self.velocity.y = 0
        local offset = self.hitBox.y - self.y + self.hitBox.height
        self.y = collisionBlock.y - offset - 0.01
        break
      end
      if self.velocity.y < 0 then
        self.velocity.y = 0
        local offset = self.hitBox.y - self.y
        self.y = collisionBlock.y + collisionBlock.height - offset + 0.01
        break
      end
    end
  end
  
  for i=1, #self.PlatformCollisionBlocks do
    local PlatformCollisionBlock = self.PlatformCollisionBlocks[i]
    if platformCollision(self.hitBox, PlatformCollisionBlock) then
      if self.velocity.y > 0 then
        self.velocity.y = 0
        local offset = self.hitBox.y - self.y + self.hitBox.height
        self.y = PlatformCollisionBlock.y - offset - 0.01
        break
      end
      --if self.velocity.y < 0 then
      --  self.velocity.y = 0
      --  local offset = self.hitBox.y - self.y
      --  self.y = PlatformCollisionBlock.y + PlatformCollisionBlock.height - offset + 0.01
      --  break
      --end
    end
  end
  
  for i=#self.coinCollisionBlocks, 1, -1 do
    local coinCollisionBlock = self.coinCollisionBlocks[i]
    if collision(self.hitBox, coinCollisionBlock) then
      table.remove(self.coinCollisionBlocks, i)
      score = score + 1
    end
  end
end