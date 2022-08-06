// DOC - extend bot module
import "Log"
import "Tile"


// extensions---
// DOC - turn the bot to direction, 0 - North, 1 - East , 2 - South, 3 - West
bot.face = function(direction)
    if direction == null then return
    while (bot.facing != direction)
        bot.left
    end while
end function

// DOC - bot will attempt to move to position (WIP) If fail to reach in 10 attempts, give up
bot.gotoSimple = function(x=0,y=0)
    attempt = 0

    log.debug ["Currently at <", bot.position.x, ",", bot.position.y,">"]
    log.debug ["Going to <", x, ",", y,">"]
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
                    log.debug(["Can't move right to <",bot.position.x+1,",",bot.position.y,">"])
                    tile = here.tile(bot.position.x+1,bot.position.y)
                    if tile then log.debug(["Blocked by ", tile.name])
                else
                    log.debug(["Can't move left to <",bot.position.x-1,",",bot.position.y,">"])
                    tile = here.tile(bot.position.x-1,bot.position.y)
                    if tile then log.debug(["Blocked by ", tile.name])

                end if

                // if collide first time, update dx then go with move y
                dx = x - bot.position.x

                // attempt to move vertically, if same y, go down
                if dy > 0 then
                    // if target is below bot
                    bot.face(2)
                    log.debug(["Turning down to <",bot.position.x,",",bot.position.y+1,">"])
                else
                    // if target is above bot
                    bot.face(0)
                    log.debug(["Turning up to <",bot.position.x,",",bot.position.y-1,">"])
                end if

                prevY = bot.position.y
                bot.forward()

                if prevY == bot.position.y then

                    // if collide second time, move vertically in opposite direction
                    if bot.facing == 0 then
                        log.debug(["Can't move up to <",bot.position.x, ",",bot.position.y-1,">"])
                        tile = here.tile(bot.position.x,bot.position.y-1)
                        if tile then log.debug(["Blocked by ", tile.name])
                        bot.face(2)
                        log.debug(["Turning down to <",bot.position.x, ",",bot.position.y+1,">"])
                    else
                        log.debug(["Can't move down to <",bot.position.x, ",",bot.position.y+1,">"])
                        tile = here.tile(bot.position.x,bot.position.y+1)
                        if tile then log.debug(["Blocked by ", tile.name])
                        bot.face(0)
                        log.debug(["Turning up to <",bot.position.x, ",",bot.position.y-1,">"])
                    end if
                    bot.forward()

                    // if collide third time
                    if prevY == bot.position.y then
                        log.error(["I'm stuck in a dead end"])
                        return
                    end if
                end if

                // if able to proceed, update dy and continue to move horizontally with while
                dx = x - bot.position.x
                dy = y - bot.position.y
            else
                // if no collide, update prevX and dx position
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
                    log.debug(["Can't move up to <",bot.position.x,",",bot.position.y-1,">"])
                    tile = here.tile(bot.position.x,bot.position.y-1)
                    if tile then log.debug(["Blocked by ", tile.name])
                else
                    log.debug(["Can't move down to <",bot.position.x,",",bot.position.y+1,">"])
                    tile = here.tile(bot.position.x,bot.position.y+1)
                    if tile then log.debug(["Blocked by ", tile.name])
                end if

                // if collide first time, update dy then go with move x
                dy = y - bot.position.y

                // attempt to move horizontally, if same x, go right
                if dx >= 0 then
                    // if target is right/same as bot
                    bot.face(1)
                    log.debug(["Turning right to <",bot.position.x+1,",",bot.position.y,">"])
                else
                    // if target is left or same lane of bot
                    bot.face(3)
                    log.debug(["Turning left to <",bot.position.x-1,",",bot.position.y,">"])
                end if

                prevX = bot.position.x
                bot.forward()

                if prevX == bot.position.x then
                    // if collide second time, move horizontally in opposite direction
                    if bot.facing == 1 then
                        log.debug(["Can't move right to <", bot.position.x+1, ",", bot.position.y, ">"])
                        tile = here.tile(bot.position.x+1,bot.position.y)
                        if tile then log.debug(["Blocked by ", tile.name])
                        bot.face(3)
                        log.debug(["Turning left to <",bot.position.x-1, ",", bot.position.y, ">"])
                    else
                        log.debug(["Can't move left to <", bot.position.x-1, ",", bot.position.y, ">"])
                        tile = here.tile(bot.position.x-1,bot.position.y)
                        if tile then log.debug(["Blocked by ", tile.name])
                        bot.face(1)
                        log.debug(["Turning rigth to <", bot.position.x+1, ",", bot.position.y, ">"])
                    end if
                    bot.forward()

                    // if collide third time
                    if prevX == bot.position.x then
                        log.error(["I'm stuck in a dead end"])
                        return
                    end if
                end if

                // if able to proceed, update dydx and continue to move vertically with while
                dx = x - bot.position.x
                dy = y - bot.position.y
            else
                // if no collide, update prevY position
                dy = y - bot.position.y
            end if
        end while
    end while
end function


// DOC - refill water
bot.refill = function()
    tool = self.getTool("wateringcan")
    if not tool then
        log.error(["Does not have watering can"])
        return
    end if

    log.debug(["Going to refill " + tool.name])
    curstep = 1
    maxstep = 100
    watertile = null
    while curstep < maxstep and not watertile
        log.debug(["Locating nearest water tile at", curstep, "away"])

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
        log.error(["Fail to find watertile within", maxstep, "steps"])
        return
    end if
    bot.goto(watertile.x,watertile.y+1)
    bot.face(0)
    bot.useTool
end function

bot.goto = function(x=0,y=0)
    if x == null then return
    // if x isa Tile then
    //     tile = x
    //     x = tile.x
    //     y = tile.y
    // end if

    if not x isa number or not y isa number then return

    log = new Log
        log.init
        log.setMode("debug")
        log.setInvoker "gotonew"

    target = new Tile.init(x,y)

    if not target or not target.ispassable then
        log.error ["[",x,",",y,"]","is not passable"]
        return
    end if

    visited = {}
    while bot.position.x != target.x or bot.position.y != target.y
        start = Tile.from(bot.position)

        log.info ["Currently at",start.x,",",start.y,]
        log.info ["Going to ",target.x,",",target.y]

        dy = start.dy(target)
        dx = start.dx(target)

        // compute initial range for search
        rangeY = range(start.y,start.y - dy)
        rangeX = range(start.x,start.x - dx)

        // set distance of all tile to infinite (max step of moving in the map)
        maxDistance = here.width * here.height



        // start with initial search space where start and end are 2 adjacent corner of a rectangle instead of whole map
        //generate searchspace with adjacent tile list of all tiles available
        // also set the distance to max steps in the map
        // compute for additional distance if path is not within grid of rangeX and rangeY
        expanded = 0
        while true
            //djikstra with guided search space
            //shortest path set
            distance = {}
            searchSpace = []

            for y in rangeY
                for x in rangeX
                    tile = Tile.init(x,y)

                    if not tile or (not tile.ispassable and tile.xy != start.xy) then continue

                    tile.neighbour = []
                    searchSpace.push(tile)

                    distance[tile.xy] = maxDistance
                    if tile.up and tile.up.ispassable and rangeX.contains(tile.up.x) and rangeY.contains(tile.up.y) then
                        tile.neighbour.push(tile.up)
                    end if

                    if tile.down and tile.down.ispassable and rangeX.contains(tile.down.x) and rangeY.contains(tile.down.y) then
                        tile.neighbour.push(tile.down)
                    end if

                    if tile.right and tile.right.ispassable and rangeX.contains(tile.right.x) and rangeY.contains(tile.right.y) then
                        tile.neighbour.push(tile.right)
                    end if

                    if tile.left and tile.left.ispassable and rangeX.contains(tile.left.x) and rangeY.contains(tile.left.y) then
                        tile.neighbour.push(tile.left)
                    end if
                end for
            end for

            count = 0
            shortestPath = {}
            computedSet = {}

            // set distance of start tile to 0 so that it is always chosen as first vertices
            distance[start.xy] = 0
            shortestPath[start.xy] = []
            // log.debug ["Initial distanceas",distance]

            while count < searchSpace.len
                verticeWithMinDistance = null
                distanceSoFar = maxDistance
                for vertice in searchSpace
                    // skip vertices that is computed
                    computed = computedSet.get(vertice.xy)

                    if computed != null then continue

                    if verticeWithMinDistance == null or distance[vertice.xy] < distanceSoFar then
                        verticeWithMinDistance = vertice
                        distanceSoFar = distance[vertice.xy]
                    end if
                end for
                // log.debug ["vertice chosen:",verticeWithMinDistance.xy]

                computedSet[verticeWithMinDistance.xy] = true

                for neighbour in verticeWithMinDistance.neighbour
                    newDistance = distance[verticeWithMinDistance.xy] + 1
                    if newDistance < distance[neighbour.xy] then
                        distance[neighbour.xy] = newDistance
                        shortestPath[neighbour.xy] = shortestPath[verticeWithMinDistance.xy] + [verticeWithMinDistance]
                    end if
                end for

                count = count + 1
            end while

            // if max distance of target not determined yet, expand search space of x by 2 and y by 2
            if distance[target.xy] == maxDistance then
                expanded = expanded + 1
                log.info ["Expanded search space ",expanded,"time(s)"]
                if rangeX.len == 1 then
                    firstMemberX = rangeX[0]
                    rangeX = [firstMemberX - 1, firstMemberX, firstMemberX + 1]
                else
                    diff = rangeX[1] - rangeX[0]
                    rangeX = [rangeX[0] - diff] + rangeX + [rangeX[-1] + diff]
                end if

                if rangeY.len == 1 then
                    firstMemberY = rangeY[0]
                    rangeY = [firstMemberY - 1, firstMemberY, firstMemberY + 1]
                else
                    diff = rangeY[1] - rangeY[0]
                    rangeY = [rangeY[0] - diff] + rangeY + [rangeY[-1] + diff]
                end if
                log.info ["New range X",rangeX]
                log.info ["New range Y",rangeY]
            else
                break
            end if
        end while
        log.debug ["Distance:",distance]
        log.debug ["Shortest Path"]
        shortestPath = shortestPath[target.xy] + [target]
        for step in shortestPath
            log.debug [step.xy]
        end for

        for step in shortestPath[1:]
            curr = Tile.from(bot.position)
            dir = curr.directionFrom(step)
            if dir == null then
                log.error ["Null direction for",curr.xy,"from",step.xy]
                break
            end if
            log.debug [step.xy,"direction:",dir]
            bot.face dir
            bot.forward
            while curr.xy == Tile.from(bot.position).xy
                bot.forward
            end while
        end for
        log.save
        return
    end while
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
            log.debug(["Found water tile at <",x,",",y,">"])
            return { "x" : x, "y" : y}
        end if
    end if
end function

// DOC - get latest tool status in inventory
bot.getTool = function(type)
    return bot.inventory.find(type,"type")
end function

bot.subscribeChat = function(player)
    // register player name
    outer.player = player

    pprint "Subscribing to chat"
    lastMessage = ""
    if world.chatMessages then
        lastMessage = world.chatMessages[-1]
    end if
    while true
        cmd = ""
        if world.chatMessages then
            lastMessage = world.chatMessages[-1]
        end if

        if cmd != lastMessage then

            result = chatCommand(cmd.trim)
            if result then
                world.chat(result)
                pprint(result)
            end if

            lastMessage = world.chatMessages[-1]
            // count.increment
            // count = world.chatMessages.len
        end if
        yield
    end while
end function

chatCommand = function(cmd)
    sender = cmd.split(": ")[0]
    commandString = cmd.split(": ")[1]

    if commandString.indexOf(":") == null then return

    result = "I don't understand " + commandString

    command = commandString.split(":")

    if command[1] == "location" then
        result = "I am at " + bot.position.area.name + "[" + bot.position.x + "," + bot.position.y + "]"
        return result
    end if

    if command[1] == "move" then
        if command.len < 4 then return
        result = "I am moving to <" + command[2] + "," + command[3] + ">"
        bot.goto(command[2].val,command[3].val)
        return result
    end if
    return result
end function
return null