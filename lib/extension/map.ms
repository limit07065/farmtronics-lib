//DOC - extension for map data type

// DOC - contains: return true if this list contains the given element.
map.contains = function(item)
	return self.indexOf(item) != null
end function 

// DOC - clone a deep copy of map passed in 
map.clone = function(srcmap)
	if not srcmap then return

	result = {}
		
	for i in srcmap.indexes
		if srcmap[i] isa map then
			result[i] = map.clone(srcmap[i])
		else
			result[i] = srcmap[i]
		end if		
	end for
	return result
end function

map.getisa = function
	return self.get("__isa")	
end function