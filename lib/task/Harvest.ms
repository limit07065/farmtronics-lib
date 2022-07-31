// DOC - task to locate all position of targets, bot will harvest all target and place to chest on left of initial position
import "Log"

// prevent reinitializing log in globals
if not globals.hasIndex("log") then 
    globals.log = new Log
    log.init
    log.setMode("debug")
end if

Harvest = {}

// DOC - constructor
Harvest.init = function(settings)    
    // configure settings from input
    self.settings = map.clone(settings)

    if not self.settings then
        self.settings = { "algo" : "simple" }
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

    // assume chest is always on left of bot initial spot
    self.settings.start = bot.position    
    targetlocations = getTargetLocations(self.settings)
    if self.settings.algo == "simple" then simpleHarvest(targetlocations)

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

// DOC - get all positions of target
getTargetLocations = function(settings)
    list = []
    for y in range (0,here.height) 
        for x in range (0, here.width)
            curr = here.tile(x,y)
            if curr and curr.hasIndex("crop") then
                crop = curr.crop
                if crop and crop.name == settings.target then //and crop.harvestable then                    
                    list.push {"x":x,"y":y,"crop":crop}
                end if
            end if
        end for
    end for
    return list
end function

// DOC - harvest by moving next to target location in list 
simpleHarvest = function(targetlocations)
    log.debug(["Using simple harvest algorithm"])    
    for targetlocation in targetlocations
        log.debug (["harvesting at " + targetlocation.x + "," + targetlocation.y])
        
        // always harvest from right             
        bot.goto(targetlocation.x + 1,targetlocation.y)
        log.debug(["At: " + bot.position.x + "," + bot.position.y])
        
        bot.face(3)
        bot.harvest                  
    end for
    log.debug(["Harvest finish"])    
end function

return Harvest