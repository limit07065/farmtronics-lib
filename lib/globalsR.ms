//import all module in directory, does not recursively import for sub-directory

globals.importall = function(directory)
    directoryPath = directory
    
    root = "/usr/lib"
    allModules = file.children(root + "/" + directoryPath)

    if not allModules then
        print "Fail to importall for " + directoryPath
        return    
    end if

    // get all files and directory within path
    for module in allModules
        if module.indexOf(".ms") then
            //trim extension and ensureImport .ms module, skip directories and other file type            
            globals.importsafe(directoryPath + "/" + module[0:module.len-3])
        end if
    end for
end function

// prevent recursive import and duplicate import
globals.importsafe = function(moduleName)
    if globals.hasIndex(moduleName) then return     
    
        globals[moduleName] = "PENDING"	// (module is being imported now)
        import moduleName
        globals[moduleName] = locals[moduleName]    
end function