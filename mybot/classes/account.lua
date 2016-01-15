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

account = {
	
-- check allow access to use 'cmd'.
-- @return true if allowed
-- @return false and msg if not allowed
-- TODO: Возможность проверки доступа не только для профилей, но и для определённых юзеров.
	check_acl = function(self, UID, cmd)
		if cmd then
			local profile = UID.iProfile
			if acl[profile] and acl[profile].tcmds and acl[profile].tcmds[cmd] or acl[profile].root then
				return true -- TODO: return 0 if success
			else
				return false, lang[32] -- TODO: return 1 & msg if error
			end
		else
			error("Class 'account' function 'check_acl' #2 'cmd' is a nil value, but expected string")
		end
	end,


	new = function(self, nick, data)
		local res = false
		if nick and data then
			if type(data) == "table" then
				accounts[nick] = data
				res, msg = api:save("accounts")
				if res then
					return true
				else 
					return res, msg
				end
			end
		end
	end,
	
	mod = function (self, nick, param)
		if type(param) == "table" then
		
		end	
	end,
	
	rm = function (self, nick)
		if accounts[nick] then
			accounts[nick] = nil
			local res, msg = api:save("accounts")
			if res then
				return true
			else 
				return res, msg
			end
		end
	end,

	get = function(self, data)
		if accounts and accounts[data] then
			return accounts[data]
		end
	end,
	
	get_total_count = function(self)
		local count = 0
		for i,v in pairs(accounts) do 
			count = count + 1 
		end
		return count
	end,
	
	get_count_for_profile = function(self, profile)
		local count = 0
		for i,v in pairs(accounts) do 
			if v.profile == profile then 
				count = count + 1
			end
		end
		return count
	end,
	
	is_higher_user = function(self, src_uid, dest_uid)
		if src_uid and dest_uid then
			if (dest_uid.iProfile <= src_uid.iProfile) or (dest_uid.iProfile == 0) then 
				return true
			end
		end
	end,

	is_higher = function (self, src_nick, dest_nick)
		local src = self:get(src_nick)
		local dest = self:get(dest_nick)
		if src and dest then
			if (dest.iprofile <= src.iprofile) or (dest.iprofile == 0) then
				return true
			end
		end
	end,
	
	is_reg = function (self, nick)
		if self:get(nick) then
			return true
		end
	end,
	
	is_hub_owner = function(self,nick)
		if def_config.hub_owners[nick] then
			return true
		end	
	end,
	
	get_users_with_profile = function (self, profile)
		local t = {}
		for i,v in pairs(accounts) do 
			if v.iprofile == profile then
				table.insert(t,i)
			end
		end
		return t
	end,

	get_users_regged_by = function (self, by)
		local t = {}
		for i,v in pairs(accounts) do 
			if v.regged_by == by then
				table.insert(t, i)
			end
		end 
		return t
	end,
}
