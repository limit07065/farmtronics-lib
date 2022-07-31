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

Log = new BaseClass        

// DOC - constructor concept for class
Log.init = function(settings)
    // prevent overwritting class
    if self.isclass then return

    if settings then 
        self.settings = map.clone(settings)
    else
        self.settings = {}
    end if
    
    // check for mode set
    if not self.settings.get("mode") then self.setMode("info")
    self.content = []   
end function

// DOC - set logging mode
Log.setMode = function(mode)
    // prevent overwritting class
    if self.isclass then return

    self.settings.mode = mode
end function

// DOC - set invoker name
Log.setInvoker = function(invoker)
    // prevent overwritting class
    if self.isclass then return

    self.settings.invoker = invoker
end function

// DOC - save log file
Log.save = function()
    // prevent overwritting class
    if self.isclass then return

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
// @deprecated, probably better to send in a list
Log.info = function(arg,arg2,arg3,arg4,arg5)
    // prevent overwritting class
    if self.isclass then return

    line = ["[info]","-", arg, arg2, arg3, arg4, arg5]    
    print line.join(" ")
    self.content.push(line.join(" "))
end function

// DOC - debug function, only printed to console in debug mode
// @deprecated, probably better to send in a list
Log.debug = function(arg,arg2,arg3,arg4,arg5)
    line = ["[debug]","-", arg, arg2, arg3, arg4, arg5]
    if self.settings.mode == "debug" then
        print line.join(" ")
    end if        
    self.content.push(line.join(" "))
end function

// DOC - error, always printed to console
// @deprecated, probably better to send in a list
Log.error = function(arg,arg2,arg3,arg4,arg5)
    line = ["[error]","-", arg, arg2, arg3, arg4, arg5]
        print line.join(" ")
            
    self.content.push(line.join(" "))
end function

// DOC - info function, always printed to console
Log.info = function(arg)
    // prevent overwritting class
    if self.isclass then return
    
    line = ["[info]","-"] + arg
    print line.join(" ")
    self.content.push(line.join(" "))
end function

// DOC - debug function, only printed to console in debug mode
// @deprecated, probably better to send in a list
Log.debug = function(arg)
    line = ["[debug]","-"] + arg
    if self.settings.mode == "debug" then
        print line.join(" ")
    end if        
    self.content.push(line.join(" "))
end function

// DOC - error, always printed to console
// @deprecated, probably better to send in a list
Log.error = function(arg)
    line = ["[error]","-"] + arg
        print line.join(" ")
            
    self.content.push(line.join(" "))
end function
return Log