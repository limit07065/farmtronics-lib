// DOC - wrapper Tile class to retrieve information for a tile based on position given
import "BaseClass"
import "Log"
// importsafe "mapUtil"
// importsafe "listUtil"
// import "Tree"
impassabletypes = [ "Building" , "Crafting", "Water", "Tree", "Character", "Stone", "Basic", "Bush", "Clump", "Fish"]

Tile = new BaseClass

Tile.classname = "Tile"

// DOC - constructor like function. Will return a new Tile object or update self depending on the class / instance invoked. Skip if x or y not provided
Tile.init = function(x,y)

    // skip if x or y not provided
    if x == null or y == null then return
    if x < 0 or y < 0 then return
    if x > here.width or y > here.height then return

    if self.isclass then
        tile = new Tile
        tile.init(x,y)
        return tile
    else
        self.x = x
        self.y = y
        self.update()
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
        tile = Tile.from(x,y)
        type = tile.type
    else
        if position != null then return
        if self.info then
            type = self.info.get("type")
        end if
    end if

     if type and impassabletypes.contains(type) then
        return false
    else
        return true
    end if
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

Tile.distanceFrom = function(tile)
    // only for instance
    if self.isclass then return
    if tile == null then return

    return abs(self.x - tile.x + self.y - tile.y)
end function

Tile.up = function()
    // only for instance
    if self.isclass then return

    tile = Tile.init(self.x, self.y-1)
    return tile
end function

Tile.down = function()
    // only for instance
    if self.isclass then return

    tile = Tile.init(self.x, self.y+1)
    return tile
end function

Tile.left = function()
    // only for instance
    if self.isclass then return
    tile = Tile.init(self.x+1, self.y)
    return tile
end function

Tile.right = function()
    // only for instance
    if self.isclass then return

    tile = Tile.init(self.x-1, self.y)
    return tile
end function

Tile.xy = function()
    // only for instance
    if self.isclass then return

    return "<" + self.x + ", " + self.y + ">"
end function
// file-scope ---
// DOC update tile info
Tile.update = function()
    // only for instance
    if self.isclass then return

    self.info = here.tile(self.x,self.y)
    self.name = null
    self.type = null

    if self.info then
        self.name = self.info.get("name")
        self.type = self.info.get("type")
    end if
end function

// DOC create a graph where start is the first element of graph
// Tile.graph = function(start,end)
//     if not start or not end return
//     if not start isa Tile or not end isa Tile then return

//     minX = min(start.x,end.x)
//     maxX = max(start.x,end.x)
//     minY = min(start.y,end.y)
//     maxY = max(start.y,end.y)

//     inrange = function(target,minX,maxX,minY,maxY)
//         if target.x < minX then return false
//         if target.x > maxX then return false
//         if target.y < minY then return false
//         if target.y > maxY then return false
//         return true
//     end function
//     graph = []
//     tileId = 0
//     for y in range(start.y, end.y)
//         for x in range (start.x, end.x)
//             tile = Tile.init(x,y)
//             graph[tileId] = []
//             up = tile.up
//             if up.ispassable and inrange(up,minX,maxX,minY,maxY) then
//                 graph[tileId].push(up)
//         end for
//     end for

//     return graph
// end function

// DOC calculate diff of x with respect to target
Tile.dx = function(target)
    // only for instance
    if self.isclass then return
    if not target or not target isa Tile then return

    return self.x - target.x
end function

// DOC calculate diff of y with respect to target
Tile.dy = function(target)
    // only for instance
    if self.isclass then return
    if not target or not target isa Tile then return

    return self.y - target.y
end function

Tile.directionFrom = function(tile)

    // log.debug ["self:",self.xy,"tile:",tile.xy]
    // only for instance
    if self.isclass then return
    if tile == null then return

    if self.distanceFrom(tile) != 1 then return

    dy = self.dy(tile)
    dx = self.dx(tile)

    // log.debug ["dx:",dx,"dy::",dy]

    if dy < 0 then return 2
    if dy > 0 then return 0
    if dx < 0 then return 1
    if dx > 0 then return 3
    return
end function

Tile.graph = function(startTile,endTile)

end function
return Tile