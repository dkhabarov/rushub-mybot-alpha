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
	options={
		short_description = lang[1],
	},
	["acl"] = function (UID,cmd, sData)
		return account:check_acl(UID, cmd)
	end,
		
	["cmd"] = function(UID, cmd, sData)
		if cmd then
			if not sData or sData == "" then
				return true, lang[2]:format(cmd)
			end
			local ascript = Core.GetScript(sData) or {}
			if not ascript.sName then
				return true, lang[3]:format(sData)
			elseif ascript.bEnabled then
				return true, lang[4]:format(sData)
			else
				local err = false
				local _, err = Core.StartScript(ascript.sName)
				if err then
					return true, lang[5]:format(ascript.sName, err)
				else
					return true, lang[6]:format(ascript.sName)
				end
			end				
		end
	end,

	["man"] = function(UID, cmd, sData)
		return true, lang[7]:gsub("%[(%S+)%]", {CMD = cmd, CURNAME=_NAME__})
	end,

}
