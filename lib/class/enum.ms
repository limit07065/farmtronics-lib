// DOC - enum represented with simple class. Order will be the integer value starting from 0, value will the the enum values
// EG: enum for directions in form of order:value: 0:North, 1:East, 2:South, 3:West 
Enum = {}
Enum.toOrder = function(value)
    return self.values[str(value)]
end function

Enum.toValue = function(order)
    return self.order[str(order)]
end function

Direction8 = new Enum
Direction8.order = {
    "0":"North",
    "1":"North East",
    "2":"East",
    "3":"South East",
    "4":"South",
    "5":"North",
    "6":"North",
    "7":"North",    
    }
