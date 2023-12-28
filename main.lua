io.stdout:setvbuf("no")

function love.load()
  --config
  Object = require "adven/lib/classic"
  love.window.setFullscreen(true, "desktop")
  
  --screen dimensions
  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()
  
  --Enviroment
  require "adven/sprite"
  require "adven/utils"
  gravity = 0.2
  background = Sprite(0, 0, "adven/src/img/background.png")
  camera = {x = 0, y = -432 + screenHeight/6}
  score = 0
  
  
  --collision system
  require "adven/collision"
  require "adven/collisionBlock"
  require "adven/coinBlock"
  floorCollision2D = {}
  PlatformCollisions2D = {}
  coinCollisions2D = {}
  for i=1, #floorCollision, 36 do
     table.insert(floorCollision2D, table.slice(floorCollision, i, i+35))
     table.insert(PlatformCollisions2D, table.slice(PlatformCollisions, i, i+35))
     table.insert(coinCollisions2D, table.slice(coinCollisions, i, i+35))
  end
  
  collisionBlocks = {}
  for i, row in ipairs(floorCollision2D) do
    for j, symbol in ipairs(row) do
      if symbol == 202 then
        table.insert(collisionBlocks, CollisionBlock((j-1)*16, (i-1)*16))
      end
    end
  end
  
  PlatformCollisionBlocks = {}
  for i, row in ipairs(PlatformCollisions2D) do
    for j, symbol in ipairs(row) do
      if symbol == 202 then
        table.insert(PlatformCollisionBlocks, CollisionBlock((j-1)*16, (i-1)*16, 4))
      end
    end
  end
  
  coinCollisionBlocks = {}
  for i, row in ipairs(coinCollisions2D) do
    for j, symbol in ipairs(row) do
      if symbol == 202 then
        table.insert(coinCollisionBlocks, CoinBlock((j-1)*16, (i-1)*16))
      end
    end
  end

  --controls
  keys_pressed = {a={pressed=false}, d={pressed=false}}
  
  --Player
  require "adven/player"
  player = Player(50, 300, "adven/src/warrior/Idle.png", collisionBlocks, PlatformCollisionBlocks, coinCollisionBlocks,
    {Idle = {imgSrc = "adven/src/warrior/Idle.png", frameRate = 8, frameBuffer = 10},
    IdleLeft = {imgSrc = "adven/src/warrior/IdleLeft.png", frameRate = 8, frameBuffer = 10},
    Run = {imgSrc = "adven/src/warrior/Run.png", frameRate = 8, frameBuffer = 10},
    RunLeft = {imgSrc = "adven/src/warrior/RunLeft.png", frameRate = 8, frameBuffer = 10},
    Jump = {imgSrc = "adven/src/warrior/Jump.png", frameRate = 2, frameBuffer = 5},
    JumpLeft = {imgSrc = "adven/src/warrior/JumpLeft.png", frameRate = 2, frameBuffer = 10},
    Fall = {imgSrc = "adven/src/warrior/Fall.png", frameRate = 2, frameBuffer = 5},
    FallLeft = {imgSrc = "adven/src/warrior/FallLeft.png", frameRate = 2, frameBuffer = 10}
    })
end

function love.keypressed(key)
  if key == "a" then
    keys_pressed.a.pressed= true
  elseif key == "d" then
    keys_pressed.d.pressed = true
  elseif key == "w" then
    player.velocity.y = -4
  elseif key == "space" then
    player.velocity.y = -4
  end
end

function love.keyreleased(key)
  if key == "a" then
    keys_pressed.a.pressed= false
  elseif key == "d" then
    keys_pressed.d.pressed = false
  end
end

function love.update(dt)
  for i, block in ipairs(coinCollisionBlocks) do
    block:update(dt)
  end
  player:update(dt)
  player.velocity.x = 0
  
  if keys_pressed.d.pressed then
    player:switchSprite("Run")
    player.velocity.x = 2
    player.lastDirection = "right"
    player:panCameraLeft()
  elseif keys_pressed.a.pressed then
    player.velocity.x = -2
    player.lastDirection = "left"
    player:switchSprite("RunLeft")
    player:panCameraRight()
  elseif player.velocity.y == 0 then
    if player.lastDirection == "right" then
      player:switchSprite("Idle")
    else
      player:switchSprite("IdleLeft")
    end
  end
  
  if player.velocity.y < 0 then
    player:panCameraDown()
    if player.lastDirection == "right" then
      player:switchSprite("Jump")
    else
      player:switchSprite("JumpLeft")
    end
  elseif player.velocity.y > 0 then
    player:panCameraUp()
    if player.lastDirection == "right" then
      player:switchSprite("Fall")
    else
      player:switchSprite("FallLeft")
    end
  end
end

function love.draw()
  love.graphics.push()
  love.graphics.scale(6, 6)
  love.graphics.translate(camera.x, camera.y)
  background:draw()
  --for i, block in ipairs(collisionBlocks) do
  --  block:draw()
  --end
  --for i, block in ipairs(PlatformCollisionBlocks) do
  --  block:draw()
  --end
  for i, block in ipairs(coinCollisionBlocks) do
    block:draw()
  end
  player:draw()
  
  love.graphics.pop()
  love.graphics.print("Score: "..score , 10, 10, 0, 4, 4)
end
