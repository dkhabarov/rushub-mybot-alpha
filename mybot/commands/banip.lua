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
		short_description="Áàí IP",
	},
	
	["acl"] = function (UID, cmd, sData)
		return account:check_acl(UID, cmd)
	end,
	
	["cmd"] = function (UID, cmd, sData)
		if not sData or sData == "" then
			return true, lang[2]:format(cmd)
		end
		local ipaddr, reason = sData:match("^(%d+%.%d+%.%d+%.%d+)%s*(.*)$")
		Core.SendToAll(ipaddr)
		if not ipaddr or not util.is_ipv4(ipaddr) then
			return true, lang[2]:format(cmd)
		end
		local dstuid = Core.GetUsers(ipaddr)
		if types:is_array(dstuid) then
			dstuid=dstuid[1] --???? 
		end
		if dstuid and account:is_higher(UID, dstuid) then
			return true, lang[100]
		
		else 
			local res, msg = ban:banip(ipaddr, reason, nil, UID)		
		end
		
		
		
	end,
}
