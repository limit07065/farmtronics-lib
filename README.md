# farmtronics-lib
miniscript code written for farmtronics mod for StarDew Valley. This project is still in development

## How to use
Your usrdisk in farmtronic should be located in save files of your game

EG:
 C:\Users\<Your User>\AppData\Roaming\StardewValley\Saves\<Save>\usrdisk

You can activate the libraries by copying files in lib/ to usrdisk\lib path.

## File naming convention
All lib files are named with class followed by R to prevent namespace conflict.

EG:
logR - will be functions written to handling loggings.
botR - extension of bot module.
hereR - extension of here in global scope.
tileR - module to compute tile info such ass passable.

## Folder directory convention

lower level libraries will be in /lib
higher level bot task will be in /bot

## High level task
harvestR - call harvestR.run(target) in startup.ms, bot will attempt to harvest and place in chest located on the left of starting location. 
