// DOC - extensions for list data type
// DOC - contains: return true if this list contains the given element.
list.contains = function(item)
	return self.indexOf(item) != null
end function 

// DOC - find exact match in list for certain index, default to name
list.find = function(item, index = "name")
	if self.len == 0 then return	
	for i in self		
		if i then 
			if i == item then return i
			if not i isa map then return
			if i.hasIndex(index) and i[index].lower == item.lower then return i
		end if
	end for			
end function

// DOC - find match in list for certain index where it contains item, index default to name
list.findLike = function(item, index = "name")
	if self.len == 0 then return	
	for i in self	
		if i then 			
			if not i isa map then return
			if i.hasIndex(index) then		
				field = i[index]
				if not field isa string then return				
				if field.lower.indexOf(item.lower) isa number then return i
			end if
		end if
	end for			
end function