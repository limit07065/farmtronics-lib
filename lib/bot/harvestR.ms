
import "botR"
import "logR"

log = logR
log.set("debug")
settings = new map
run = function(target)
    map["target"] = target

    // assume chest is always on left of bot initial spot
    startingLocation = bot.position
    targetlocations = gettargetlocations()
    for targetlocation in targetlocations
        log.debug ("harvesting at " + targetlocation.x + "," + targetlocation.y)
        
        // always harvest from right             
        bot.goto(targetlocation.x + 1,targetlocation.y,log)
        log.debug("At: " + bot.position.x + "," + bot.position.y)
        
        bot.face(3)
        bot.harvest                  
    end for
    
    log.debug ("returning to starting location: " + startingLocation.x + "," + startingLocation.y)
    bot.goto(startingLocation.x,startingLocation.y,log)
    bot.face(3)    
    for item in bot.inventory        
        if item and item.name == settings.target then
            bot.select(settings.target)
            bot.placeItem()
        end if
    end for
    log.shutdown
end function

gettargetlocations = function()
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

