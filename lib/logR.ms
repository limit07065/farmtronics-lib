content = []
settings = {"mode":"info"}
// info function
info = function(arg,arg2,arg3,arg4,arg5)
    
    line = ["[INFO]","-", arg, arg2, arg3, arg4, arg5]
    line.remove
    print line.join(" ")
    content.push(line.join(" "))
end function

// debug function
debug = function(arg,arg2,arg3,arg4,arg5)
    line = ["[DEBUG]","-", arg, arg2, arg3, arg4, arg5]
    if settings.mode == "debug" then
        print line.join(" ")
    end if        
    content.push(line.join(" "))
end function

set = function(mode)
    settings.mode = mode
end function

// shutdown and save log file
shutdown = function()
    cd "/usr/logs"
    fileName = [world.year,world.season,world.dayOfWeek,world.timeOfDay,time,".log"].join("-")
    logFile = file.open(fileName)
    for line in content
        logFile.writeLine(line)
    end for
    logFile.close()
end function
