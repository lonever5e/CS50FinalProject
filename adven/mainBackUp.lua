io.stdout:setvbuf("no")

function love.load()
  --config
  Object = require "adven/lib/classic"
  love.window.setFullscreen(true, "desktop")
  
  --screen
  screenWidth = love.graphics.getWidth()
  screenHeight = love.graphics.getHeight()
  
  --Enviroment
  require "adven/sprite"
  require "adven/utils"
  gravity = 0.5
  background = Sprite(0, 0, "adven/src/img/background.png")
  
  --collision system
  require "adven/collision"
  require "adven/collisionBlock"
  floorCollision2D = {}
  PlatformCollisions2D = {}
  for i=1, #floorCollision, 36 do
     table.insert(floorCollision2D, table.slice(floorCollision, i, i+35))
     table.insert(PlatformCollisions2D, table.slice(PlatformCollisions, i, i+35))
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
        table.insert(PlatformCollisionBlocks, CollisionBlock((j-1)*16, (i-1)*16))
      end
    end
  end

  --controls
  keys_pressed = {a={pressed=false}, d={pressed=false}}
  
  --Entity
  require "adven/entity"
  
  --Player
  require "adven/player"
  player = Player(50, 300, "adven/src/warrior/Idle.png", collisionBlocks)
end

function love.keypressed(key)
  if key == "a" then
    keys_pressed.a.pressed= true
  elseif key == "d" then
    keys_pressed.d.pressed = true
  elseif key == "w" then
    player.velocity.y = -8
  elseif key == "space" then
    player.velocity.y = -8
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
  player:update(dt)
  player.velocity.x = 0
  if keys_pressed.d.pressed then
    player.velocity.x = 5
  elseif keys_pressed.a.pressed then
    player.velocity.x = -5
  end
end

function love.draw()
  love.graphics.push()
  love.graphics.scale(6, 6)
  love.graphics.translate(0, -432 + screenHeight/6)
  background:draw()
  for i, block in ipairs(collisionBlocks) do
    block:draw()
  end
  for i, block in ipairs(PlatformCollisionBlocks) do
    block:draw()
  end
  player:draw()
  love.graphics.pop()
end
