// DOC - wrapper Tile class to retrieve information for a tile based on position given
import "Tree"

impassabletypes = [ "Building" , "Crafting","Water"]

Tile = new BaseClass

Tile.classname = "Tile"

// DOC - constructor like function. Will return a new Tile object or update self depending on the class / instance invoked. Skip if x or y not provided
Tile.init = function(x,y)

    // skip if x or y not provided
    if x == null or y == null then return

    if self.isclass then
        tile = new Tile
        tile.init(x,y)
        return tile
    else
        self.x = x
        self.y = y
        updateTile(self)
    end if
end function

// DOC - return a Tile object from bot position or any position with x and y property. Set to self if self is a Tile
Tile.from = function(position)
    // skip if x or y not provided
    x = position.get("x")
    y = position.get("y")
        
    if x == null or  y == null then return

    if self.isclass then
        tile = new Tile
        tile.init(x,y) 
        return tile
    else
        self.x = x
        self.y = y
        self.info = here.tile(x,y)
    end if   
end function

// DOC - check if position provided is passable. For class call, check @param position. For instance call, does not allow position and only feedback based on self position
Tile.ispassable = function(position)
    type = null
    // different behaviour based on class / instance
    if self.isclass then 
        if position == null then return
    
        x = position.get("x")
        y = position.get("y")
        if x == null or  y == null then return
        tile = Tile.init(x,y)    
        type = tile.type       
    else
        if position != null then return        
        type = self.info.get("type")                  
    end if 

     if type and impassabletypes.contains(type) then 
        return false
    else
        return true
    end if
end function

// DOC - return x and y string in a list
Tile.xyOnly = function(list)
    // skip if called by instance
    if not self.isclass then return
    reduce = function(a,b)
        if a == null and b == null then return []
        if b == null then return ["<" + a.x + "," + a.y + ">"]
        return a.push("<" + b.x + "," + b.y + ">")
    end function
    return list.reduce(@reduce)
end function

Tile.buildDistanceTree = function(list)
    // only for instance
    if self.isclass then return

    tree = null
    for tile in list
        distance = abs(self.x - tile.x) + abs(self.y - tile.y)
        if tree == null then 
            tree = Tree.init(distance,tile)
        else
            tree.insert(Tree.init(distance,tile))
        end if
    end for
end function

// file-scope ---
// DOC update tile info
updateTile = function(tile)
    tile.info = here.tile(tile.x,tile.y)
    tile.name = null
    tile.type = null

    if tile.info then 
        tile.name = tile.info.get("name")
        tile.type = tile.info.get("type")   
    end if
end function

return Tile