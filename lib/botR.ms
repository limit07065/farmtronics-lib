bot.face = function(direction)
    while (bot.facing != direction)
        bot.left
    end while
end function

bot.goto = function(x=0,y=0)
    
    attempt = 0    
    log.debug("Currently at " + bot.position.x + "," + bot.position.y)
    while bot.position.x != x or bot.position.y != y
        log.debug("Going to " + x + "," + y)
        attempt = attempt + 1
        if attempt > 10 then
            log.debug("I'm stuck!")
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

return null

