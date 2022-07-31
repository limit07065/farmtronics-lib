// DOC - wrapper Tile class to retrieve information for a tile based on position given
impassabletypes = [ "Building" , "Crafting" ]

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

    // different behaviour based on class / instance
    if self.isclass then 
        if position == null then return
    
        x = position.get("x")
        y = position.get("y")
        if x == null or  y == null then return

        tile = Tile.init(x,y)    
        if tile.type and impassabletypes.contains(tile.type) then 
            return false
        else
            return true
        end if
    else
        if position != null then return        
        type = self.info.get("type")       
        if type and impassabletypes.contains(type) then return false
        
    end if
    

    return true    
end function

// file-scope ---
// DOC update tile info
updateTile = function(tile)
    tile.info = here.tile(tile.x,tile.y)
    tile.name = null
    tile.type = null

    if tile.info then tile.name = tile.info.name
    if tile.info then tile.type = tile.info.get("type")
end function

return Tile