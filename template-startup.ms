additionalimports = ["/usr/lib/bot"]
for path in additionalimports
    if not env.importPaths.contains("/usr/lib/bot") then
        env.importPaths.push(path)
    end if
end for

if bot.name == null then
    print "startup.ms ran for home computer"
    exit
end if

//extends list and map type

list.contains = function(item)
	return self.indexOf(item) != null
end function

map.contains = function(item)
	return self.indexOf(item) != null
end function

