import "logR"
import "botR"

// configure log settings at global scope
globals.log = new Log
log.set("debug")

Water = new {}
// run function
Water.run = function()
    log.debug("Starts watering")
    bot.goto(56,18)
    log.shutdown
end function

return Water