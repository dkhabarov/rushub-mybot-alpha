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


ban = {

	get_default_ban_time = function (self)
		return util.convert_to_second(def_config["default_ban_time"])
	end,
	
	drop_user = function (self, source_uid, tuid)
		if account:is_higher_user(source_uid, tuid) then
			return nil, api:get_lang_string(100)
		end
--[[		
		if account:get(tuid.sNick) then
			local violations = account:get(tuid.sNick).violations.drops_count or 0
			accounts[tuid.sNick].violations.drops_count = violations + 1
		end
]]
		local res, err = Core.Disconnect(tuid)
		if res then
			return true
		else
			return nil, err 
		end
	end,
	
	newban = function (self, banlist, snick, sip, sreason, stime, by)
		local lists = {["ips"]=true}
		if not lists[banlist] then
			return nil, ("Error: list %s diesn't exist"):format(banlist)
		end
		if banlist == "ips" then
			if bans[banlist][var] then
				return nil, "It is already banned"
			end
			var = sip
		elseif banlist == "nicks" then
			var = snick
		end		
		local subl = bans[banlist][var] or {}
		if snick then
			subl.nick = snick
		end
			
		if sreason then
			subl.sreason = sreason
		end
		subl.createdate = os.time()
		subl.by = (by or botname)
		if stime and types:is_string(stime) and stime:match("^%d+$") then
			stime = tonumber(stime)
		elseif stime and types:is_string(stime) and stime:match("%a%d+") then
			stime = util.convert_to_second(stime) or self:get_default_ban_time()
		end
		if stime and stime > 0 then
			subl.expires = os.time() + stime
		elseif stime and stime == 0 then
			subl.expires = os.time() + self:get_default_ban_time()
		end
		
		if types:is_array(sip) then
			if sip.start and sip._end then
				subl.start = sip.start
				subl._end = sip._end
			end
		end
		
		bans[banlist][var] = subl
		local res, msg = api:save("bans")
		if res then
			return true
		else 
			bans[banlist].var = nil
			return nil, msg
		end
	end,
	--[[
	temp_ban_nick = function (self, nick, reason, bantime, by)
		
		
	end,]]
	
	banip = function(self, ipaddr, reason, time, uidby)
		local bantime = time or self:get_default_ban_time()
		local by = uidby.sNick or botname
		local res, msg = self:newban("ips",  nil, ipaddr, reason, bantime, by)
		if res then
			count = self:disconnect_all_users_by_ip(ipaddr)
			return true, count
		else 
			return nil, msg
		end
	end,
	
	disconnect_all_users_by_ip = function (self, ip)
		local count = 0
		local users = Core.GetUsers(ip, true)
		if type(users) == 'table' then
			for _, user in pairs(users) do 
				Core.Disconnect(user)
				count = count + 1
			end
		else 
			Core.Disconnect(users)
			count = 1
		end
		return count
	end,
	
	expiration = function (self, _type, target)
		if tables.is_in_array(bans, _type) then
		
		else 
			return nil, ("Invalid type=%s"):format(_type)
		end
	end,
}
