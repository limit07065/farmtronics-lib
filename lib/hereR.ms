
// get type, name and indexes of all non-null tiles in current map
here.tiles = function(shownull=false)
    filename = here.name
    f = file.open("/usr/logs/" + filename + ".tile")
    for y in range(0,here.height-1)
        for x in range (0,here.width-1)
        cur = here.tile(x,y)
            if cur then
                f.writeLine("<" + x + "," + y + "> - type: " + cur.type + ", name: " + cur.name + ", indexes: " +cur.indexes)
            else if shownull then                    
                f.writeLine("<" + x + "," + y + "> - null")
            end if
        end for
    end for
    f.close()
end function

// get all unique type of non-null tiles in current map
here.utype = function(shownull=false)
    filename = here.name
    f = file.open("/usr/logs/" + filename + "-utype.tile")
    utype = []
    for y in range(0,here.height-1)
        for x in range (0,here.width-1)
        cur = here.tile(x,y)
            if cur then
                f.writeLine("<" + x + "," + y + "> - type: " + cur.type + ", name: " + cur.name + ", indexes: " +cur.indexes)
            else if shownull then                    
                f.writeLine("<" + x + "," + y + "> - null")
            end if
        end for
    end for
    f.close()
end function