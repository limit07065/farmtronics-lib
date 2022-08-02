// DOC - task to break all boulders and tree in quarry
import "Log"
import "Tile"
import "Tree"

Quarry = new BaseClass

// DOC - constructor
Quarry.init = function(settings)    
    // configure settings from input
    self.settings = map.clone(settings)

    if not self.settings then
        self.settings = { "algo" : "simple" , "direction":2 }
    end if   

    // prevent reinitializing log in globals
    if not globals.hasIndex("log") then 
        globals.log = new Log
        log.init
        log.setMode("debug")
        log.setInvoker("Quarry")
    end if
    
end function

Quarry.run = function    
    if not self.settings.hasIndex("algo") or not self.settings.hasIndex("direction") then 
        log.error(["Algo, direction not set"])
        return
    end if
    startTile = Tile.init(bot.position.x,bot.position.y)

    if self.settings.algo == "simple" then simpleQuarryWork(startTile,self.settings)

end function

simpleQuarryWork = function(startTile,settings)
    direction = settings.direction
    width = 17
    if settings.get("width") != null then width = settings.get("width")
    height = 9
    if settings.get("height") != null then height = settings.get("height")
    log.info(["Start tile:",startTile.x,",",startTile.y])
    log.info(["Doing quarry work for",width,"x",height])
    rightend = startTile.x
    leftend = startTile.x - (width - 1)

    if bot.energy == 0 then 
        log.info(["Too tired to work >_<"])
        return
    end if

    bot.face(direction)
    bot.clearAndMove    

    lane = bot.position.y - startTile.y
    while bot.energy > 0
        lane = bot.position.y - startTile.y
        log.info(["Clearing lane",lane])
        if bot.position.x == rightend then        
            bot.face(3)            
        else if bot.position.x == leftend then
            bot.face(1)
        else
            log.error(["Not reaching either end. bot.position.x:",bot.position.x,"leftend:",leftend,"rightend:",rightend])            
            break
        end if
        
        bot.clearAndMove(width-1)

        
        log.info(["Cleared lane",lane])

        if lane == height then
            log.info(["Finish clearing quary"])
            break
        end if

        bot.face(direction)
        bot.clearAndMove
        
    end while

    if bot.energy == 0 then
        log.info(["Out of energy","Cleared",lane,"lane"])
    end if

    bot.goto(startTile.x,startTile.y)
    
end function
return Quarry