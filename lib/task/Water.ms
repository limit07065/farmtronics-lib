// DOC - task to locate all position of targets, bot will harvest all target and place to chest on left of initial position
import "Log"

// prevent reinitializing log in globals
if not globals.hasIndex("log") then     
    globals.log = new Log
    log.init
    log.setMode("debug")
end if

Water = new {}

// DOC - constructor10
Water.init = function(settings)
    // configure settings from input
    self.settings = map.clone(settings)

    if not self.settings then
        self.settings = { "algo" : "simple" }
    end if   

    // start if all settings available
    if self.settings.hasIndex("algo") then self.run()
end function

// DOC - run function
Water.run = function()
    cropLocations = getCropLocations(self.settings)
    while cropLocations
        if self.settings.algo == "simple" then simpleWatering(self.settings,cropLocations)
        cropLocations = getCropLocations(self.settings)
    end while

    log.save
end function

// DOC - get all positions of crops that are dry
getCropLocations = function(settings)
    list = []
    for y in range (0,here.height) 
        for x in range (0, here.width)
            curr = here.tile(x,y)
            if curr and curr.hasIndex("crop") and curr.hasIndex("dry") then                
                if curr.crop and curr.dry then
                    list.push {"x":x,"y":y,"crop":curr.crop}
                end if
            end if
        end for
    end for
    return list
end function

// DOC - simple watering algorithm, goes to next crop in list and water
simpleWatering = function(settings,cropLocations)
    log.debug("Using simple watering algorithm")
    log.debug("Crops to water:",cropLocations.len)
    
    for cropLocation in cropLocations
        log.debug ("watering " + cropLocation.x + "," + cropLocation.y)
        
        // always water from right             
        bot.goto(cropLocation.x + 1,cropLocation.y)
        log.debug("At: " + bot.position.x + "," + bot.position.y)
        
        bot.face(3)
        bot.water                  
    end for
    log.debug("Water finish")   
end function
return Water