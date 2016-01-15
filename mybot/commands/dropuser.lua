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
		short_description = lang[103]
	},
	["acl"] = function (UID, cmd, sData)
		return account:check_acl(UID, cmd)
	end,
	
	["cmd"] = function (UID, cmd, sData)
		if not sData or sData == "" then
			return true,lang[2]:format(cmd)
		end
		local dstuid = Core.GetUser(sData)
		if not dstuid then
			return true, lang[73]
		end
		local res, msg = ban:drop_user(UID, dstuid)
		if res then
			api:send_to_ops(lang[101]:format(UID.sNick, dstuid.sNick))
			return true, "OK"
		else 
			api:send_to_hub_owners(lang[110]:format(UID.sNick, (dstuid.sNick and dstuid.sNick or "?")))
			return true, msg
		end
	end,
	
	["man"] = function (UID, cmd, sData)
		return true, lang[111]:gsub("%[(%S+)%]", {CMD = cmd})
	end

}
