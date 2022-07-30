// DOC - Log class to support logging at info and debug levels

// DOC - call on import to check for logs directory created
initdir = function()
    dirname = "/usr/logs"
    if file.exists(dirname) and file.info(dirname).isDirectory then 
        return
    else        
        mkdir dirname
    end if
end function
initdir

Log = {}        

// DOC - constructor concept for class
Log.init = function(settings)    
    self.settings = { "mode" : "info" }
    self.content = []

    if settings then
        for index in settings.indexes
            self.settings[index] = settings[index]
        end for
    end if
end function

// DOC - set logging mode
Log.setMode = function(mode)
    self.settings.mode = mode
end function

// DOC - set invoker name
Log.setInvoker = function(invoker)
    self.settings.invoker = invoker
end function

// DOC - save log file
Log.save = function()
    cd "/usr/logs"
    fileName = [self.settings.invoker,world.year,world.season,world.dayOfWeek,world.timeOfDay,time].join("-") + ".log"
    logFile = file.open(fileName)
    for line in self.content
        logFile.writeLine(line)
    end for
    logFile.close()
    print "Saved log to " + fileName
end function

// DOC - info function, always printed to console
Log.info = function(arg,arg2,arg3,arg4,arg5)
    line = ["[info]","-", arg, arg2, arg3, arg4, arg5]    
    print line.join(" ")
    self.content.push(line.join(" "))
end function

// DOC - debug function, only printed to console in debug mode
Log.debug = function(arg,arg2,arg3,arg4,arg5)
    line = ["[debug]","-", arg, arg2, arg3, arg4, arg5]
    if self.settings.mode == "debug" then
        print line.join(" ")
    end if        
    self.content.push(line.join(" "))
end function

// DOC - error, always printed to console
Log.error = function(arg,arg2,arg3,arg4,arg5)
    line = ["[error]","-", arg, arg2, arg3, arg4, arg5]
        print line.join(" ")
            
    self.content.push(line.join(" "))
end function
return Log