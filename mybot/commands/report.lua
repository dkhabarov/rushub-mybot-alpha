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
			short_description = lang[35],
		},
		
		["acl"] = function (UID, cmd, sData)
			return account:check_acl(UID, cmd)
		end,
		
		["cmd"] = function (UID, cmd, sData)
			if cmd then
				if not sData or sData == "" then
					return true, lang[2]:format(cmd)
				end
				local target, reason = sData:match("^(%S+)%s(%S+)$")
				if not target then
					return true, lang[2]:format(cmd)
				elseif not reason then
					return true, lang[2]:format(cmd)
				end
				local target_uid = Core.GetUser(target)
				if not target_uid then
					return true, lang[36]:format(target)
				else
					api:send_to_ops(lang[37]:format(target_uid.sNick, target_uid.sIP, UID.sNick, UID.sIP, (reason and reason or "")))
					return true, lang[38]:format(target_uid.sNick)
				end
			end
		end,
		
		["man"] = function (UID, cmd, sData)
			return true, lang[39]
		end,

}
