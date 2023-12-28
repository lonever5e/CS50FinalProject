# CS50FinalProject
**A vertical platform game created in lua for CS50 final project**

## Controls
**W or Space** - Jump
**A** - Move Left
**D** - Move Right

## Enviroment
The Map was created in Tiled Map  Editor. The Map contains PlatformCollisions, FloorCollisions, Coins layers. These layer enables the Player to stand move on platform collect coins. The map exported from tiled in .lua format and the required table is obtained. A Camera object is created to keep track of the player.

## Player
Player contains multiple sprites based on the action and direction. Animation effect is created based on this sprite images. Player object over each frame checks for collision with floorBlocks, platformBlocks and coinBlocks. Each Block have different property.

### FloorBlock
Detects collision with player both horizontally and vertically. It resets the position of player outside of the FloorBlock in the direction it came from.

### PlatformBlock
Detects collision with player only vertically. It sets player on top the block.

### CoinBlock
Detects collision with player both horizontally and vertically. It doesn't affect player position. But, it gets disappeard (collected) once collisioni happens.

Devlopement of this game provides insight to OOPs concept in action and experience in lua.

## Credits
This game was originally done by Chris Courses in YouTube using JavaScript. I have just added the coin feature and done it in lua.
source - https://youtu.be/rTVoyWu8r6g?si=77QW0ROtqkZaiRg8