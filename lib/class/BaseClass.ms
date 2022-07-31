BaseClass = {
    "isClass":true,
}

BaseClass.isclass = function
    // if self has __isa 
    if not self.getisa or self.getisa.hasIndex("isClass") then 
        return true
    else
        return false
    end if
end function

return BaseClass