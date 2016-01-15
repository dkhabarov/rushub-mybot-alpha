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
		short_description = lang[79],
	},
	["acl"] = function (UID, cmd, sData)
		return account:check_acl(UID, cmd)
	end,
	
	["cmd"] = function (UID, cmd, sData)
		local current_account = account:get(UID.sNick)
		if not current_account then
			return true, lang[73]
		end
		if not sData then
			return true,lang[2]:format(cmd)
		end
		if sData ~= current_account['password'] then
			return true, lang[57]
		end
		local res, msg=account:rm(UID.sNick)
		if res then
			UID.iProfile = -1
			if UID.bInOpList then
				UID.bInOpList = false
			elseif UID.bInIpList then
				UID.bInIpList = false
			elseif UID.bHide then
				UID.bHide = false
			elseif UID.bKick then
				UID.bKick = false
			elseif UID.bRedirect then
				UID.bRedirect = false
			end
			api:send_to_ops(lang[80]:format(UID.sNick))
			return true, lang[81]
		else 
			-- Может быть, что в загруженной таблице пользователь удалён, а допустим удалить из файла не удалось.
			-- В таком случае, сообщим о проблемах, а аккаунт удалим позже.
			accounts[UID.sNick] = current_account
			api:send_to_hub_owners(lang[82]:format(UID.sNick,msg))
			return true, lang[83]
		end
		
	end,
	
	["man"] = function (UID, cmd, sData)
		return true, lang[84]:gsub("%[(%S+)%]", {CMD = cmd})
	end,

}
