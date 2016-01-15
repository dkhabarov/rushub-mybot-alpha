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

filter = {

	nick_chars = function (self, nick)
		return nick:find("[^"..(def_config.allow_chars_in_nicks):gsub("[^A-Za-z0-9]","%%%1").."]")	
	end,
	
	check_password = function (self, sData)
		local sData = tostring(sData)
		if sData:match("([%$%|%s])") or sData:find("&#36;", 1, 1) or sData:find("&#124;", 1, 1) then
			return nil, api:get_lang_string(59)
		elseif sData and #sData >= def_config.security.password_max_len then
			return nil, api:get_lang_string(52):format(def_config.security.password_max_len)
		elseif sData and #sData <= def_config.security.password_min_len then
			return nil, lang[58]:format(def_config.security.password_min_len)
		else
			return true
		end
	end,

	get_field_limit = function (self, UID, field)
		local available_fields = {
			["max_ip_session"]=true,["min_share"]=true, ["max_share"] = true,
			["min_slots"] = true, ["max_slots"] = true,
			["max_hubs"] = true,
		}
		if not field or not available_fields[field] then
			return nil, "Unknown limit field '"..field.."'"
		end
		local current_account = account:get(UID.sNick)
		local this_profile = acl[UID.iProfile]
		if current_account and current_account.limits and current_account.limits[field] then
			return current_account.limits[field]
		end
		if this_profile and this_profile.limits and this_profile.limits[field] then
			return this_profile.limits[field]
		end
		if def_config.rules and def_config.rules[field] then
			return def_config.rules[field]
		end
	end,
	
	check_login_limits = function (self, UID)
		local uids_for_ip = Core.GetUsers(UID.sIP, true)
   		if uids_for_ip and #uids_for_ip > (self:get_field_limit(UID, "max_ip_session") or 2) then
   			local nicks = ""
			for _,uid in ipairs(uids_for_ip) do
				if uid.sNick ~= UID.sNick then
					nicks = nicks..uid.sNick..(#uids_for_ip >= 3 and "," or "")
				end
			end
   		    Core.SendToUser(UID, lang[104]:format(nicks), botname)
   		    Core.Disconnect(UID)
   		end
   		local min_share = (self:get_field_limit(UID, "min_share") or 0)
  		if (UID.iShare or 0) < min_share then
 			Core.SendToUser(UID, lang[105]:format(util.convert_bytes_to_normal_size(min_share), util.convert_bytes_to_normal_size((UID.iShare or 0))), botname)
 			Core.Disconnect(UID)
 		end
 		local max_share = (self:get_field_limit(UID,"max_share") or 1e+14*1.100) --1e+14*1.100=100.044 TB
		if (UID.iShare or 0) > max_share then
			Core.SendToUser(UID, lang[106]:format(util.convert_bytes_to_normal_size(max_share), util.convert_bytes_to_normal_size((UID.iShare or 0))), botname)
			Core.Disconnect(UID)
		end
		local min_slots = (self:get_field_limit(UID, "min_slots") or 0)
		if UID.iSlots < min_slots then
			Core.SendToUser(UID, lang[107]:format(min_slots, UID.iSlots), botname)
			Core.Disconnect(UID)
		end
		local max_slots = (self:get_field_limit(UID, "max_slots") or 1000)
		if UID.iSlots > max_slots then
			Core.SendToUser(UID, lang[108]:format(max_slots, UID.iSlots), botname)
			Core.Disconnect(UID)
		end
		local max_hubs =(self:get_field_limit(UID, "max_hubs") or 1000)
		local hubs_count = (UID.iUsHubs + UID.iRegHubs + UID.iOpHubs)
		if hubs_count > max_hubs then
			Core.SendToUser(UID, "количество подключённых хабов", botname)
			Core.Disconnect(UID)
		end
		if def_config.rules.hub_only_reg_users and not account:get(UID.sNick) then
			Core.SendToUser(UID, lang[109], botname)
			Core.Disconnect(UID.sNick)
		end
	end,
	
}
