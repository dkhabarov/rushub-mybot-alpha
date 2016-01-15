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
		short_description = lang[50],
	},
		
	["acl"] = function (UID, cmd, sData)
		return account:check_acl(UID, cmd)
	end,
		
	["cmd"] = function (UID, cmd, sData)
		if account:get(UID.sNick) then
			return true, lang[51]
		end
		if not sData then
			return true, lang[2]:format(cmd)
		end
		local res, msg = filter:check_password(sData)
		if not res then
			return true, msg
		end
		if (UID.iShare or 0) < def_config.rules.min_share_register then
			return true, lang[65]:format(util.convert_bytes_to_normal_size(UID.iShare or 0), util.convert_bytes_to_normal_size(def_config.rules.min_share_register))
		end
		local profile = def_config.default_profile and default_profile or 3
		local t_this_account = {
			reg_date = os.time(), 
			password = sData,
			last_session_time = os.time(),
			ip_registred = UID.sIP,
			last_ip = UID.sIP,
			total_online_time = 0,
			regged_by = UID.sNick,
			iprofile = profile
			}
		
		local bool,err = account:new(UID.sNick,t_this_account)
		if bool then
			UID.iProfile = profile
			api:send_to_ops(lang[60]:format(UID.sNick, profile, UID.sIP))
			if def_config.welcome_new_registred_users_in_main_chat then
				Core.SendToAllExceptNicks({UID.sNick}, lang[64]:format(UID.sNick), botname)
			end	
			return true, lang[61]:format(Config.sHubName, UID.sNick, sData)
		else
			api:send_to_hub_owners(lang[62]:format(UID.sNick,err))
			return true, lang[63]
		end
	end,
	
	["man"] = function (UID, cmd, sData)
			local RULE1,RULE2, RULE3 = "","",""
			if def_config.rules.min_share_register and def_config.rules.min_share_register > 0 then
				RULE1 = lang[67]:format(util.convert_bytes_to_normal_size(def_config.rules.min_share_register))
			end
			if def_config.security.password_min_len and def_config.security.password_min_len > 0 then
				RULE2 = lang[68]:format(def_config.security.password_min_len)
			end
			
			if def_config.security.password_max_len and def_config.security.password_max_len > 0 then
				RULE3 = lang[69]:format(def_config.security.password_max_len)
			end
			local RULES=lang[71]..RULE1..RULE2..RULE3
			
		return true, lang[70]:gsub("%[(%S+)%]", {CMD = cmd, RULES=RULES})
	end,

}
