//import globalsR and all module in datatype folder
import "first"

// import high level bot script
// TO UNCOMMENT
// importsafe "Water"
// importsafe "Harvest"

// startup program for home computer
if not bot.name then
    print "startup.ms ran for home computer"
    exit
end if

// startup program for bot
// if bot.name == "Bot <Number>" then    
//     Water.init()   
//     log.save 
//     exit
// end if

// if bot.name == "Bot <Number>" then
//     Harvest.init()
//     Harvest.setTarget("Potato")
//     Harvest.run()
// end if