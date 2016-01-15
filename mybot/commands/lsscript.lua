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
		short_description=lang[15],
	},
	
	["acl"] = function (UID, cmd, sData)
		return account:check_acl(UID, cmd)
	end,
		
	["cmd"] = function (UID, cmd, sData)
		if cmd then
			if not sData then
				local script_list=""
				for i, v in ipairs(Core.GetScripts()) do
					script_list = script_list..(("\t%s\t%s\t\t%s\t\t%s\n"):format(i > 9 and i or "0"..i, v.bEnabled and lang[13] or lang[14], v.sName, v.iMemUsage ~= 0 and (" (%s kb)"):format(v.iMemUsage) or ""))
				end
				return true, lang[16]..script_list	
			elseif sData ~= nil then
				local script=Core.GetScript(sData)
				if not script.sName then
					return true, lang[3]:format(sData)
				else
					return true, lang[17]:format(script.sName, script.bEnabled and lang[13] or lang[14], script.iMemUsage ~= 0 and (" (%s kb)"):format(script.iMemUsage) or "")	
				end
			end
		end
	end,
	
	["man"] = function (UID, cmd, sData)
		return true, lang[18]:gsub("%[(%S+)%]", {CMD = cmd, CURNAME=_NAME__})
	end,
}
