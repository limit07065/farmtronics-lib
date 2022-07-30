// DOC - extend bot module

// extensions---
// DOC - turn the bot to direction, 0 - North, 1 - East , 2 - South, 3 - West
bot.face = function(direction)
    while (bot.facing != direction)
        bot.left
    end while
end function

// DOC - bot will attempt to move to position (WIP) If fail to reach in 10 attempts, give up
bot.goto = function(x=0,y=0)
    
    attempt = 0    
    log.debug("Currently at " + bot.position.x + "," + bot.position.y)
    while bot.position.x != x or bot.position.y != y
        log.debug("Going to " + x + "," + y)
        attempt = attempt + 1
        if attempt > 10 then
            log.error("I'm stuck!")
            return
        end if

        dx = x - bot.position.x
        dy = y - bot.position.y

        if dx != 0 then
            xDirection = ""
            if dx > 0 then
                bot.face(1)
                 xDirection = xDirection + "Moving to right "
            else if dx < 0 then
                bot.face(3)
                 xDirection = xDirection + "Moving to left "
            end if
            
             xDirection = xDirection + abs(dx) + " steps"
            log.debug xDirection
            for i in range(1,abs(dx))
                bot.forward()
            end for
        end if

        if dy != 0 then
            yDirection = ""
            if dy > 0 then
                bot.face(2)
                 yDirection = yDirection + "Moving down "
            else if dy < 0 then
                bot.face(0)
                 yDirection = yDirection + "Moving up "
            end if
             yDirection = yDirection + abs(dy) +" steps"
            log.debug yDirection
            
            for i in range (1,abs(dy))
                bot.forward()
            end for
        end if
    end while
end function

// DOC - use watering tool to water, check watering can remaining water after action
bot.water = function()
    tool = self.getTool("wateringcan")
    
    if not tool then 
        log.error("Does not have watering can")
        return
    end if

    // check water level before watering
    if tool.waterLeft == 0 then
        log.debug("Out of water.")
        bot.refill()
    end if   

    
    bot.select(tool.name)
    bot.useTool

    // check water level after watering
    if tool.waterLeft == 0 then
        log.debug("Out of water.")
        bot.refill()
    end if
end function

// DOC - refill water
bot.refill = function()  
    tool = self.getTool("wateringcan")
    if not tool then 
        log.error("Does not have watering can")
        return
    end if

    log.debug("Going to refill " + tool.name)
    curstep = 1
    maxstep = 100
    watertile = null
    while curstep < maxstep and not watertile
        log.debug("Locating nearest water tile at", curstep, "away")
        
        for i in range (1,curstep)
            
            dy = i
            dx = curstep - i            

            //q1
            x = bot.position.x + dx
            y = bot.position.y - dy
            watertile = iswatertile(x,y)
            if watertile then break

             //q2
            x = bot.position.x + dx
            y = bot.position.y + dy
            log.debug("x:",x,"y",y)
            watertile = iswatertile(x,y)
            if watertile then break

             //q1
            x = bot.position.x - dx
            y = bot.position.y + dy
            watertile = iswatertile(x,y)
            if watertile then break

             //q1
            x = bot.position.x - dx
            y = bot.position.y - dy
            watertile = iswatertile(x,y)
            if watertile then break
        end for    
        curstep = curstep + 1   
    end while 
    if not watertile then
        log.error("Fail to find watertile within",maxstep,"steps")
        return
    end if
    bot.goto(watertile.x,watertile.y+1)
    bot.face(0)
    bot.useTool
end function

iswatertile = function(x,y)    
    tile = here.tile(x, y)
    if tile then        
        if tile.name.lower == "water" then
            log.debug("Found water tile at <",x,",",y,">")
            return { "x" : x, "y" : y}
        end if
    end if
end function

// DOC - get latest tool status in inventory
bot.getTool = function(type)
    return bot.inventory.find(type,"type")
end function
