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
-- http://opensource.hub21.ru/rushub-script-manager/issues
-- ***************************************************************************

api = {

	get_lang_string = function(self, int)
		if not int then
			error('bad argument #1 \'int\' is a nil value, but expected number')
		elseif lang[int] then
			return lang[int]
		else 
			return (('Langstring %d = undefined'):format(int))
		end
	end,
	
	get_lang_info = function(self)
		return ('\tDescription: %s\n\tAuthor: %s\n\tVersion: %d\n'):format(lang.info.description,lang.info.author,lang.info.version)
	end,	
		
	get_hub_users_limit = function (self)
		local cur = Config.iUsersLimit
		if cur == -1 then
			return 32000
		end
		return cur
	end,
	
	get_online_ops = function (self)
		local users = Core.GetUsers() or {}
		local st_table = {}
		for index, value in pairs(users) do
			if value.iProfile and acl[value.iProfile] and acl[value.iProfile].is_real_operator then
				table.insert(st_table, value)
			end
		end
		return st_table
	end,
	
	send_to_ops = function(self,data, pm)
		for index, value in pairs(self:get_online_ops()) do
			if value then
				if pm then
					Core.SendToUser(value, data, botname, botname)
				else
					Core.SendToUser(value, data, botname)
				end
			end
		end
	end,
	
	send_to_hub_owners = function(self, msg)
		if type(def_config.hub_owners) == 'table' then
			for nick,bool in pairs(def_config.hub_owners) do 
				if bool and Core.GetUser(nick) then
					Core.SendToUser(nick, msg, botname, botname)
				end
			end
		elseif type(def_config.hub_owners) == 'string' then
			if Core.GetUser(def_config.hub_owners) then
				Core.SendToUser(def_config.hub_owners, msg, botname, botname)
			end
		end
	end,
	
	-- TODO: Функция уведомления об использовании команды только тех, кому была доступна эта команда.
--	send_to_allowed_profiles = function(msg, cmd)
		
--	end,
	

	save = function (self,data)
		if not data then
			return nil, "No data specified"
		end
		--print(tables.SerializeToString(data))
		local tfiles = {
			["accounts"] = {_MYCFGDIR.."/etc/registred_users.t", "accounts"},
			["bans"] = {_MYCFGDIR.."/etc/bans.t", "bans"},
			["command_aliases"] = {_MYCFGDIR.."/etc/command_aliases.t", "command_aliases"}
		}	
		data = data:lower()
		if tfiles[data] then
			local filename = tfiles[data][1]
			local tablename = tfiles[data][2]
			local bool, err = tables.Save_File(filename, _G[tablename], tablename)
			if not bool then
				return nil, err
			else 
				return true
			end
		end
	end,

	save_all = function (self)
		local dbs={["accounts"] = true, ["bans"] = true, ["command_aliases"] = true}
		for index, value in pairs(dbs) do 
			if value then
				local res, msg = self:save(index)
				if not res then
					self:send_to_hub_owners(msg)
				end
			end
		end
	end,

	-- По причине "убиения" функции Core.SetConfig делаем кастыль, который в случае успеха возвратит true.
	-- Про сообщения об ошибке можно забыть. :(
	set_hub_config = function (variable, value)  
		Config[variable] = value 
		return Config[variable] == value 
	end,


	plugin_events_validator = function(self, name)
		name = name:match('^(%S+)%.lua$')
		valid = {['OnSuccessAuth']=true,['OnThisIsLoad']=true}
		if name and valid[name] then
			return true
		end
	end,
}
