// DOC extend here module for better tile info or save to external files

// attr---
//cache non-null tiles position for reuse
here.cache = {"tiles":[]}

// methods---
// get position of all tiles or cached tiles depends on input usecache
gettiles = function(usecache)
    tiles = []
    if usecache then
        for y in range(0,here.height-1)
            for x in range (0,here.width-1)
                tiles.push(new { "x": x, "y" : y })
            end for
        end for
    else
        tiles = here.cache.tiles
    end if  
    return tiles
end function

// extensions---
// DOC - print type, name and indexes of all non-null tiles in current map to a file in logs/ directory
here.tiles = function(shownull=false,clearcache = false)
    shouldcache = clearcache or here.cache.tiles == []

    if shouldcache then here.cache.tiles = []     
    tiles = gettiles(shouldcache)
    
    filename = "/usr/logs/" + here.name + "-" + time + ".tile"
    f = file.open(filename)
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
    print "saved " + filename
end function

// DOC - get all unique types of non-null tiles in current map
here.utype = function(clearcache = false)    
    shouldcache = clearcache or here.cache.tiles == []

    if shouldcache then here.cache.tiles = []     
    tiles = gettiles(shouldcache)    
     
    filename = "/usr/logs/" + here.name + "-utype-" +  time + ".tile" 
    f = file.open(filename)

    utype = []   
        
    for tile in tiles        
        cur = here.tile(tile.x,tile.y)
            if cur then
                if shouldcache then
                    here.cache.tiles.push({ "x": tile.x, "y" : tile.y })
                end if       

                if not utype.contains(cur.type) then
                    utype.push(cur.type)
                    f.writeLine("<" + tile.x + "," + tile.y + "> - type: " + cur.type + ", name: " + cur.name + ", indexes: " +cur.indexes)
                end if
            end if       
    end for
    f.close()
    print "saved " + filename
end function

// DOC - get all tile info of non-null tiles
// here.type