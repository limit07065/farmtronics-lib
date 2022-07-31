// DOC - always the first script to be imported in order to extend globals for some useful methods and init import path

// attr---
root = "/usr/lib/"

// methods---
// DOC - init settings for global such as import path
init = function()
    for item in file.children(root)
        info = file.info(root + item)
        if info.isDirectory then                 
            if not env.importPaths.indexOf(info.path) then
                env.importPaths.push(info.path)
            end if
        end if
    end for
end function

// extensions---
// DOC - allow import of all modules in same directory
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

// DOC - Only call importsafe in primary programs such as startup.ms or if you intend to import to globals scope. Prevents recursive import and duplicate import in globals scope. Imported module should still use "import" if the import is only meant for locals.
globals.importsafe = function(moduleName)
    if globals.hasIndex(moduleName) and globals[moduleName] then return
        globals[moduleName] = "PENDING"	// (module is being imported now)
        import moduleName
        globals[moduleName] = locals[moduleName]    
end function

// invocations---
init
importall "extensions"
importsafe "BaseClass"