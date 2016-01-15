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
			short_description = lang[33],
		},
		
		["acl"] = function (UID, cmd, sData)
			return account:check_acl(UID, cmd)
		end,
	
		["cmd"] = function (UID, cmd, sData)
			local msg = ""
			for commandname in pairs(def_commands) do 
				if commandname and account:check_acl(UID, commandname) then
					if def_commands[commandname].options.hide_in_help ~= true then -- TODO: Сортировка команд по профилю и алфовиту.
						msg = msg.."\r\n\t+"..commandname.."\t\t - "..def_commands[commandname].options.short_description
					end
				end
			end
			return true, lang[34]..msg
		end,
	
		["man"] = function (UID, cmd, sData)
			return false
		end,
}
