

command = {
	options = {
		short_description = "docs for cmd"
	},
	["acl"] = function (UID, cmd, sData)
		return true-- account:check_acl(UID, cmd)
	end,
	
	["cmd"] = function (UID, cmd, sData)
		local h = io.open(_MYCFGDIR.."/commands.doc.txt","a+")
		if h then
			Core.SendToAll("Opened")
			for commandname in pairs(def_commands) do 
				if commandname and def_commands[commandname]["man"] then
					_,doc = def_commands[commandname]["man"](UID, commandname, sData)
					if doc then
							h:write(doc.."\r\n"..string.rep("-",60))
					else 
						Core.SendToAll("err "..commandname)	
					end
				end
			end 
		else 
			Core.SendToAll("Err")
		end
		h:close()
	end,

}
