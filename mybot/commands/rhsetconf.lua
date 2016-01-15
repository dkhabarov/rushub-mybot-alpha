-- ***************************************************************************
-- mybot - This is a bot for rushub.
-- Copyright (c) 2013 Denis 'Saymon21' Khabarov (admin@saymon21-root.pro)

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License version 3
-- as published by the Free Software Foundation.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- ***************************************************************************
-- Bug reports and feature requests please send to issue tracker at:
-- https://dev.saymon21-root.pro/projects/lua-mybot
-- ***************************************************************************
command = {
	options = {
		short_description = lang[42],
	},
		
	["acl"] = function (UID, cmd, sData)
		return account:check_acl(UID, cmd)
	end,
	
	["cmd"] = function (UID, cmd, sData)
		if cmd then
			if not sData or sData == "" then
				return true, lang[2]:format(cmd)
			end
			local variable,value = sData:match("(%S+)%=(.+)")
			if not variable then
				return true, lang[2]:format(cmd)
			elseif not value then
				return true, lang[2]:format(cmd)
			elseif not Config[variable] then
				return true, lang[43]:format(variable)
			else		
				local oldvalue = Config[variable]
				local res = api:set_hub_config(variable, value)
				if res then
					api:send_to_hub_owners(lang[44]:format(UID.sNick, UID.sIP, variable, (oldvalue and oldvalue or ""), (value and value or "")))					
					if variable == "sTopic" then
						Core.SendToAll("$HubTopic "..value)
					end
					return true, "OK"
				else 
					api:send_to_hub_owners(lang[85]:format(UID.sNick, UID.sIP, variable, value))
					return true, "FAIL"
				end
			end	
		end
	end,
	
	["man"] = function (UID,cmd, sData)
		return true,lang[86]:gsub("%[(%S+)%]", {CMD = cmd})
	end,
}
