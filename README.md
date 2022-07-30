# Farmtronics lib

Miniscript code written for farmtronics mod of StarDew Valley. This project is still in development

## Usage

Enable the libraries by copying files in lib/ to usrdisk\lib path.
Usrdisk in farmtronic should be located in save files of your game
EG:
C:\Users\<Your User>\AppData\Roaming\StardewValley\Saves\<Save>\usrdisk
A stardew valley mod may be available in future to support easier installation of farmtronics script

## Project Structure

- Globals extension
- Datatype extension
- Bot extension
- Log class

#### Folder directory convention

lower level libraries will be in /lib
higher level bot task will be in /bot

### High level task

1. Harvest - calls Harvest.init and configure **target** in startup.ms, bot will locate all target and place in chest located on the left of starting location.

2. Water - calls Water.init in startup.ms, bot will locate all crops that are dry and water them. Will automatically refill watering can if it is empty

### Caveats

1. Do not import directly scripts with name that is exist as variables in globals scrope. This might result in unintended overwrite and break the code.
