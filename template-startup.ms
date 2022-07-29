//import globalsR and all module in datatype folder
import "globalsR"
importall "datatype"

// init settings
additionalimportdirectories = ["/usr/lib/bot","/usr/lib/datatype"]
for directory in additionalimportdirectories
    if not env.importPaths.contains(directory) then
        env.importPaths.push(directory)
    end if
end for

// import high level bot script
// TO UNCOMMENT
// importsafe "waterR"
// importsafe "harvestR"

// startup program for home computer
if not bot.name then
    print "startup.ms ran for home computer"
    exit
end if

// startup program for bot
// TO UNCOMMENT
// if bot.name == "<BOT NAME>" then
//     waterR.run()
//     exit
// end if

// if bot.name == "<BOT NAME>" then
// TO UNCOMMENT
//     harvestR.run("<TARGET>")
//     exit
// end if