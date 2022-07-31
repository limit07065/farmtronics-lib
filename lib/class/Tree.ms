// DOC - tree implementation
Tree = new BaseClass

// DOC - constructor
Tree.init = function(key,data)
    // skip if x or y not provided
    if key == null then return

    if self.isclass then
        tree = new Tree
        tree.key = key
        tree.data = data
        tree.left = null    
        tree.right = null 
        return tree
    else
        self.key = key
        self.data = data
        self.left = null    
        self.right = null    
    end if
end function

// DOC - insert a node to tree
Tree.insert = function(node)

    // prevent overwritting class
    if self.isclass then return

    if node.key < self.key then
        if self.left == null then 
            self.left = node
        else
            self.left.insert(node)
        end if
    else
        if self.right == null then 
            self.right = node
        else
            self.right.insert(node)
        end if
    end if
end function

// DOC - delete a node from tree
Tree.delete = function(node)
    // prevent overwritting class
    if self.isclass then return

    if node.key < self.key then
        self.left.delete(node)
    else if node.key > self.key then
        self.right.delete(node)
    else
        if self.left == null then 
            self = self.right
        else if self.right == null then
            self = self.left
        else
            node = self.right.min            
            if self.key == node.key then
                node = null
            else
                self.key = node.key
                node = null
            end if

        end if
end function

Tree.min = function
    // prevent overwritting class
    if self.isclass then return

    node = self
    while node.left
        node = node.left
    end while
    return node
end function

Tree.max = function
    // prevent overwritting class
    if self.isclass then return

    node = self
    while node.right
        node = node.right
    end while
    return node
end function

Tree.inorder = function
    // prevent overwritting class
    if self.isclass then return

    list = []
    
    if self.left then list = list + self.left.inorder
    list = list + [self]
    if self.right then list = list + self.right.inorder

    return list
end function

return Tree