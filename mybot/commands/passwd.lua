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
		short_description = lang[66],
	},
	["acl"] = function (UID, cmd, sData)
		return account:check_acl(UID,cmd)
	end,
	
	["cmd"] = function (UID, cmd, sData)
		local current_account = account:get(UID.sNick)
		if not current_account then
			return true, lang[73]
		end
		if not sData then
			return true, lang[2]:format(cmd)
		end
		local oldpassword, newpassword = sData:match("(%S+)%s(%S+)")
		if not oldpassword then
			return true, lang[2]:format(cmd)
		elseif not newpassword then
			return true, lang[2]:format(cmd)
		elseif oldpassword == newpassword then
			return true, lang[77]
		end
		if oldpassword ~= current_account['password'] then
			return true, lang[72]
		end
		local res, msg = filter:check_password(newpassword)
		if not res then
			return true, msg
		end
		accounts[UID.sNick].password = newpassword
		local res, msg = api:save("accounts")
		if res then
			return true, lang[74]
		else
			accounts[UID.sNick].password = oldpassword
			api:send_to_hub_owners(lang[75]:format(UID.sNick,err))
			return true, lang[76]
		end
	
	end,
	
	["man"] = function (UID, cmd, sData)
		return true, lang[78]:gsub("%[(%S+)%]", {CMD = cmd})
	end,

}
