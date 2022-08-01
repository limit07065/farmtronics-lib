// DOC - task to locate all position of targets, bot will harvest all target and place to chest on left of initial position
import "Log"
import "Tile"
import "Tree"

Harvest = {}

// DOC - constructor
Harvest.init = function(settings)    
    // configure settings from input
    self.settings = map.clone(settings)

    if not self.settings then
        self.settings = { "algo" : "simple" }
    end if   

    // prevent reinitializing log in globals
    if not globals.hasIndex("log") then 
        globals.log = new Log
        log.init
        log.setMode("debug")
        log.setInvoker("Harvest")
    end if

    // start if all settings available
    if self.settings.hasIndex("algo") and self.settings.hasIndex("target") then self.run()
end function

// DOC - set target in settings
Harvest.setTarget = function(target)    
    // configure settings from input
    self.settings.target = target    
end function

// DOC - start task
Harvest.run = function()
    if not self.settings.hasIndex("target") or not self.settings.hasIndex("algo") then 
        log.error(["Target or algo not set"])
        return
    end if

    log.info(["Harvesting ",self.settings.target])
    // assume chest is always on left of bot initial spot
    self.settings.start = bot.position    
    targetlocations = getTargetLocationList(self.settings)
    while targetlocations
        if self.settings.algo == "simple" then simpleHarvest(targetlocations)
        if self.settings.algo == "simpleNearest" then simpleNearestHarvest(targetlocations,self.settings.target)
        targetlocations = refreshTargetLocationList(targetlocations)        
    end while

    log.debug (["returning to starting location: " + self.settings.start.x + "," + self.settings.start.y])
    bot.goto(self.settings.start.x,self.settings.start.y)
    bot.face(3)    
    for item in bot.inventory        
        if item and item.name == self.settings.target then
            bot.select(self.settings.target)
            bot.placeItem()
        end if
    end for

    log.save
end function

// DOC - get all positions of target in a list
getTargetLocationList = function(settings)    
    list = []
    for y in range (0,here.height) 
        for x in range (0, here.width)
            tile = Tile.init(x,y)
            if istarget(tile,settings.target) then list.push(tile)
        end for
    end for
    return list
end function

// DOC - harvest by moving to next target location in list 
simpleHarvest = function(targetlocations)
    log.debug(["Using simple harvest algorithm"])    
    for targetlocation in targetlocations
        log.debug (["harvesting " + targetlocation.x + "," + targetlocation.y])
        
        // always harvest from right             
        bot.goto(targetlocation.x + 1,targetlocation.y)
        log.debug(["At: " + bot.position.x + "," + bot.position.y])
        
        bot.face(3)
        if not bot.harvest then
            log.error(["Fail to harvest <",targetlocation.x,",",targetlocation.y,">"])
        end if                    

    end for
    log.debug(["Harvest finish"])    
end function

// DOC - harvest by moving to nearest target location in list without checking for impassable 
simpleNearestHarvest = function(targetlocations,target)
    log.info("Not working yet")
    return
    log.debug(["Using simpleNearest harvest algorithm"])
    targetCount = targetlocations.len
    limit = 0
    while targetCount > 0 and limit < 1
        limit.increment
        curstep = 0
        maxstep = 100
        targetTile = null            
        while curstep < maxstep and not targetTile
            curstep = curstep + 1 
            log.debug(["Locating nearest target tile at", curstep, "away"])
            
            for i in range (1,curstep)                
                dy = i
                dx = curstep - i            

                //q1                
                x = bot.position.x + dx
                y = bot.position.y - dy
                tile = Tile.init(x,y)                
                if istarget(tile, target) then
                    targetTile = tile
                    break
                end if                

                //q2
                x = bot.position.x + dx
                y = bot.position.y + dy            
                tile = Tile.init(x,y)                
                if istarget(tile, target) then
                    targetTile = tile
                    break
                end if

                //q3
                x = bot.position.x - dx
                y = bot.position.y + dy
                tile = Tile.init(x,y)                
                if istarget(tile, target) then
                    targetTile = tile
                    break
                end if

                //q4
                x = bot.position.x - dx
                y = bot.position.y - dy
                tile = Tile.init(x,y)                
                if istarget(tile, target) then
                    targetTile = tile
                    break
                end if
            end for              
        end while
        // determine bot position to harvest
        tilebot = Tile.init(bot.position.x,bot.position.y)
        log.debug([tilebot.distanceFrom(targetTile.up),targetTile.up])

        harvestPosition = null
        if targetTile.up.ispassable then
            harvestPosition = Tree.init(tilebot.distanceFrom(targetTile.up),targetTile.up)
        end if

        if harvestPosition == null and targetTile.down.ispassable then
            harvestPosition = Tree.init(tilebot.distanceFrom(targetTile.down),targetTile.down)
        else
            harvestPosition.insert(Tree.init(tilebot.distanceFrom(targetTile.down),targetTile.down))
        end if

        if harvestPosition == null and targetTile.left.ispassable then
            harvestPosition = Tree.init(tilebot.distanceFrom(targetTile.left),targetTile.left)
        else
            harvestPosition.insert(Tree.init(tilebot.distanceFrom(targetTile.left),targetTile.left))
        end if

        if harvestPosition == null and targetTile.right.ispassable then
            harvestPosition = Tree.init(tilebot.distanceFrom(targetTile.right),targetTile.right)
        else
            harvestPosition.insert(Tree.init(tilebot.distanceFrom(targetTile.right),targetTile.right))    
        end if

        if harvestPosition == null then 
            log.error(["No passable tile beside ",targetTile.xy])
            targetCount.decrement
        else
            nearestTile = harvestPosition.min.data
            log.debug(["Nearest tile:", nearestTile.xy,"distance:",harvestPosition.min.key])
            bot.goto(nearestTile.x,nearestTile.y)
            bot.face(nearestTile.fromDirection)
            if bot.harvest then targetCount.decrement
        end if    
    end while 
    if not watertile then
        log.error(["Fail to find watertile within", maxstep, "steps"])
        return
    end if     
    for targetlocation in targetlocations
        log.debug (["harvesting " + targetlocation.x + "," + targetlocation.y])
        
        // always harvest from right             
        bot.goto(targetlocation.x + 1,targetlocation.y)
        log.debug(["At: " + bot.position.x + "," + bot.position.y])
        
        bot.face(3)
        bot.harvest                  
    end for
    log.debug(["Harvest finish"])    
end function

// DOC - check if all targetlocations are harvested
refreshTargetLocationList = function(list)    
    result = []
    for tile in list        
        if tile.info.crop.harvestable then                          
            result.push(tile)            
        end if       
    end for
    return result
end function

istarget = function(tile,target)    
    if tile and tile.info then        
        crop = tile.info.get("crop")         
        if crop != null and crop.get("name") == target then
            log.debug([Tile.xy,crop.name]) 
            return true       
        end if
    end if
    return false    
end function
return Harvest