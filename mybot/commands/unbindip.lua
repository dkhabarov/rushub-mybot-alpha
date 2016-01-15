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
		short_description = lang[91],
		special_acl = {
			[0] = {all = true,}, -- Может устанавливать привязку для всех профилей
			[1] = {[0] = false, [1] = false, [2] = true, [3]= true,} -- Может устанавливать привязку только для профиля 2,3.
		},
	},
		
	["acl"] = function (UID, cmd, sData)
		return account:check_acl(UID, cmd)
	end,
	
	["cmd"] = function (UID, cmd, sData)
		if not sData or sData == "" then
			return true, lang[2]:format(cmd)
		end
		local current_account = account:get(UID.sNick)
		if not current_account then
			return true, lang[73]
		end
		local account_to_bind = account:get(sData)
		if not account_to_bind then
			return true, lang[73]
		end
	
		if def_commands[cmd].options.special_acl[UID.iProfile] then
			if not def_commands[cmd].options.special_acl[UID.iProfile].all or def_commands[cmd].options.special_acl[UID.iProfile][account_to_bind.iprofile] then
				return true, lang[32]
			end
		end
	
		account_to_bind.bindip = nil
		local res, err = api:save("accounts")	
		if res then
			return true, "OK"
		else 
			api:send_to_hub_owners(lang[94]:format(nick, err))
			return true,  lang[95]
		end
	
	end,
	
	["man"] = function (UID, cmd, sData)
		return true, lang[96]:gsub("%[(%S+)%]", {CMD = cmd})
	end,
}
