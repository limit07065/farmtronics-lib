// DOC - Log class to support logging at info and debug levels
import "BaseClass"

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
Log.init = function()
    // prevent overwritting class
    if self.isclass then return
    self.settings = {}
    self.settings.mode = "info"
    self.settings.saveOnError = true
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
Log.save = function(error)
    // prevent overwritting class
    if self.isclass then return

    cd "/usr/logs"
    fileName = [self.settings.get("invoker"),world.year,world.season,world.dayOfWeek,world.timeOfDay,time]

    if error != null then
        fileName.replace(self.settings.get("invoker"),error)
    end if
    fileName.removeVal(null,true)
    fileName = fileName.join("-") + ".log"
    logFile = file.open(fileName)
    if self.content.len == 0 then
        print "Nothing to save"
    end if
    for line in self.content
        logFile.writeLine(line)
    end for
    logFile.close()
    print "Saved log to " + fileName
end function

// DOC - info function, always printed to console
Log.info = function(arg)
    // prevent overwritting class
    if self.isclass then return

    if not arg isa list then arg = [arg]

    line = ["[info]","-"] + arg
    print line.join(" ")
    self.content.push(line.join(" "))
end function

// DOC - debug function, only printed to console in debug mode
Log.debug = function(arg)
     // prevent overwritting class
    if self.isclass then return

    if not arg isa list then arg = [arg]

    line = ["[debug]","-"] + arg
    if self.settings.mode == "debug" then
        print line.join(" ")
    end if
    self.content.push(line.join(" "))
end function

// DOC - error, always printed to console
Log.error = function(arg)
     // prevent overwritting class
    if self.isclass then return

    if not arg isa list then arg = [arg]

    line = ["[error]","-"] + arg
        print line.join(" ")

    self.content.push(line.join(" "))
    if self.settings.saveOnError then
        self.save "error"
    end if
end function
return Log