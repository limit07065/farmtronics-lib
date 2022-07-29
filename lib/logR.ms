Log = {
        "content":[],
        "settings":{ "mode":"info"},        
    }        

// info function
Log.info = function(arg,arg2,arg3,arg4,arg5)
    line = ["[INFO]","-", arg, arg2, arg3, arg4, arg5]
    line.remove
    print line.join(" ")
    self.content.push(line.join(" "))
end function

// debug function
Log.debug = function(arg,arg2,arg3,arg4,arg5)
    line = ["[DEBUG]","-", arg, arg2, arg3, arg4, arg5]
    if self.settings.mode == "debug" then
        print line.join(" ")
    end if        
    self.content.push(line.join(" "))
end function

Log.set = function(mode)
    self.settings.mode = mode
end function

// shutdown and save log file
Log.shutdown = function()
    cd "/usr/logs"
    fileName = [world.year,world.season,world.dayOfWeek,world.timeOfDay,time,".log"].join("-")
    logFile = file.open(fileName)
    for line in self.content
        logFile.writeLine(line)
    end for
    logFile.close()
end function

//enable Log class in global scope
globals.Log = Log

//initialize log folder if doesn't exist
init = function()
    dirs = file.children("/usr")
    exist = false
    for dir in dirs
        if dir == "logs" then 
            exist = true
            break    
        end if
    end for

    if not exist then
    mkdir "/usr/logs"
    end if
end function
init()
return null