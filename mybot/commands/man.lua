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
		short_description = lang[98],
	},
		
	["acl"] = function (UID, cmd, sData)
		return account:check_acl(UID, cmd)
	end,
	
	["cmd"] = function (UID, cmd, sData)
		if not sData or sData == "" then
			return true, lang[2]:format(cmd)
		end
		local sData = sData:lower()
		if not def_commands[sData] then
			return true, lang[97]:format(sData)
		end
		if not account:check_acl(UID, sData) then
			return true, lang[32]
		end
		local res, msg = def_commands[sData]["man"](UID, sData, sData)
		if res then
			return true, msg
		else 
			return true, lang[97]:format(sData)
		end
	end,

	["man"] = function (UID, cmd, sData)
		return true, lang[99]:gsub("%[(%S+)%]", {CMD = cmd})
	end,
}
