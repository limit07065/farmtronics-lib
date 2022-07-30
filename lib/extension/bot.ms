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
    
    log.debug("Currently at <", bot.position.x, ",", bot.position.y,">")
    log.debug("Going to <", x, ",", y,">")
    while bot.position.x != x or bot.position.y != y
        attempt = attempt + 1
        if attempt > 10 then
            log.error("I'm stuck!")
            return
        end if

        dx = x - bot.position.x
        dy = y - bot.position.y

        // while not same x, move horizontally
        while dx != 0           
            // move horizontally towards target
            if dx > 0 then
                bot.face(1)                         
            else if dx < 0 then
                bot.face(3)                
            end if            
            
            prevX = bot.position.x
            bot.forward()            
            
            if prevX == bot.position.x then
                if bot.facing == 1 then
                    log.debug("Can't move right to <",bot.position.x+1,",",bot.position.y,">")
                    tile = here.tile(bot.position.x+1,bot.position.y)
                    if tile then log.debug("Blocked by ", tile.name)
                else
                    log.debug("Can't move left to <",bot.position.x-1,",",bot.position.y,">")
                    tile = here.tile(bot.position.x-1,bot.position.y)
                    if tile then log.debug("Blocked by ", tile.name)                    
                    
                end if

                // if collide first time, update dx then go with move y             
                dx = x - bot.position.x

                // attempt to move vertically, if same y, go down
                if dy > 0 then
                    // if target is below bot                    
                    bot.face(2)                    
                    log.debug("Turning down to <",bot.position.x,",",bot.position.y+1,">")
                else
                    // if target is above bot                    
                    bot.face(0)
                    log.debug("Turning up to <",bot.position.x,",",bot.position.y-1,">")
                end if                

                prevY = bot.position.y
                bot.forward()

                if prevY == bot.position.y then
                    
                    // if collide second time, move vertically in opposite direction
                    if bot.facing == 0 then
                        log.debug("Can't move up to <",bot.position.x, ",",bot.position.y-1,">")                        
                        tile = here.tile(bot.position.x,bot.position.y-1)
                        if tile then log.debug("Blocked by ", tile.name)
                        bot.face(2)
                        log.debug("Turning down to <",bot.position.x, ",",bot.position.y+1,">")                                                
                    else
                        log.debug("Can't move down to <",bot.position.x, ",",bot.position.y+1,">")
                        tile = here.tile(bot.position.x,bot.position.y+1)
                        if tile then log.debug("Blocked by ", tile.name)
                        bot.face(0)
                        log.debug("Turning up to <",bot.position.x, ",",bot.position.y-1,">")                                                
                    end if                    
                    bot.forward()

                    // if collide third time
                    if prevY == bot.position.y then
                        log.error("I'm stuck in a dead end")                    
                        return
                    end if                
                end if 
                
                // if able to proceed, update dy and continue to move horizontally with while
                dx = x - bot.position.x
                dy = y - bot.position.y
            else
                // if no collide, update prevX and dx position                
                prevX = bot.position.x
                dx = x - bot.position.x
            end if           
        end while

        while dy != 0
            // move horizontally towards target
            if dy > 0 then
                bot.face(2)                         
            else if dy < 0 then
                bot.face(0)                
            end if   

            prevY = bot.position.y      
            bot.forward()
            if prevY == bot.position.y then
                if bot.facing == 0 then
                    log.debug("Can't move up to <",bot.position.x,",",bot.position.y-1,">")                    
                    tile = here.tile(bot.position.x,bot.position.y-1)
                    if tile then log.debug("Blocked by ", tile.name) 
                else
                    log.debug("Can't move down to <",bot.position.x,",",bot.position.y+1,">")
                    tile = here.tile(bot.position.x,bot.position.y+1)
                    if tile then log.debug("Blocked by ", tile.name)                    
                end if

                // if collide first time, update dy then go with move x             
                dy = y - bot.position.y

                // attempt to move horizontally, if same x, go right
                if dx >= 0 then
                    // if target is right/same as bot                    
                    bot.face(1)
                    log.debug("Turning right to <",bot.position.x+1,",",bot.position.y,">")
                else
                    // if target is left or same lane of bot                    
                    bot.face(3)
                    log.debug("Turning left to <",bot.position.x-1,",",bot.position.y,">")
                end if                

                prevX = bot.position.x
                bot.forward()

                if prevX == bot.position.x then
                    // if collide second time, move horizontally in opposite direction
                    if bot.facing == 1 then
                        log.debug("Can't move right to <", bot.position.x+1, ",", bot.position.y, ">")
                        tile = here.tile(bot.position.x+1,bot.position.y)
                        if tile then log.debug("Blocked by ", tile.name)
                        bot.face(3)
                        log.debug("Turning left to <",bot.position.x-1, ",", bot.position.y, ">")                        
                    else
                        log.debug("Can't move left to <", bot.position.x-1, ",", bot.position.y, ">")
                        tile = here.tile(bot.position.x-1,bot.position.y)
                        if tile then log.debug("Blocked by ", tile.name)
                        bot.face(1)
                        log.debug("Turning rigth to <", bot.position.x+1, ",", bot.position.y, ">")                        
                    end if                    
                    bot.forward()

                    // if collide third time
                    if prevX == bot.position.x then
                        log.error("I'm stuck in a dead end")                    
                        return
                    end if                
                end if 
                
                // if able to proceed, update dydx and continue to move vertically with while
                dx = x - bot.position.x
                dy = y - bot.position.y
            else
                // if no collide, update prevY position                
                prevY = bot.position.y
                dy = y - bot.position.y
            end if 
        end while
    end while
end function

// DOC - use watering tool to water, check water level before and after water
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
            watertile = iswatertile(x,y)
            if watertile then break

             //q3
            x = bot.position.x - dx
            y = bot.position.y + dy
            watertile = iswatertile(x,y)
            if watertile then break

             //q4
            x = bot.position.x - dx
            y = bot.position.y - dy
            watertile = iswatertile(x,y)
            if watertile then break
        end for    
        curstep = curstep + 1   
    end while 
    if not watertile then
        log.error("Fail to find watertile within", maxstep, "steps")
        return
    end if
    bot.goto(watertile.x,watertile.y+1)
    bot.face(0)
    bot.useTool
end function

// DOC - temporary private function to represent direction of target position. It is represented using number 0 to 7 with North as 0, rotating clockwise to NorthWest as 7.
// N = 0, NE = 1, E = 2, SE = 3, S = 4, SW = 5, W = 6, NW = 7
direction = function(targetX,targetY)
    x = bot.position.x
    y = bot.position.y
    
    if x == targetX and y == targetY then return 
    if x == targetX and y > targetY then return 0
    if x < targetX and y > targetY then return 1
    if x < targetX and y == targetY then return 2
    if x < targetX and y < targetY then return 3
    if x == targetX and y < targetY then return 4
    if x > targetX and y < targetY then return 5
    if x > targetX and y == targetY then return 6
    if x > targetX and y > targetY then return 7    
end function

// DOC - temporary private function to check if tile is a water tile. Considering to refactor this
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