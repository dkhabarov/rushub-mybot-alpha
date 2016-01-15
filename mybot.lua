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
-- Contstants definition
_MYVERSION = "0.1"
_TRACEBACK = debug.traceback -- enable debug
_MYCFGDIR = Core.sScriptsDir.."mybot"
_CMD_NO_PERMISSION = 1
_CMD_SUCCESS = 0
_CMD_ERR_USE = 2
_CMD_SERVICE_ERR = 3 
package.cpath = package.cpath..";".._MYCFGDIR.."/modules/?.so;".._MYCFGDIR.."/modules/?.dll;".._MYCFGDIR.."modules/?.dylib"
package.path = package.path..";".._MYCFGDIR.."/modules/?.lua;".._MYCFGDIR.."/modules/?/init.lua"
lang_file = Config.sLangPath.."scripts/"..Config.sLang.."/mybot.lang" -- Definition language file
def_commands = {}
plugin_events={}
_MYFILES = {
	lang_file,
	_MYCFGDIR.."/classes/api.lua",
	_MYCFGDIR.."/classes/account.lua",
	_MYCFGDIR.."/classes/filter.lua",
	_MYCFGDIR.."/classes/ban.lua",
	_MYCFGDIR.."/classes/types.lua",
	_MYCFGDIR.."/etc/main.lua",
	_MYCFGDIR.."/etc/acl.lua",
	_MYCFGDIR.."/etc/registred_users.t",
	_MYCFGDIR.."/etc/command_aliases.t",
	_MYCFGDIR.."/etc/bans.t",
	}


function script_load(script)
	local res, err = pcall(dofile,script)
	if res then
		return true
	else 
		print('Error '..script..': '..err)
		Core.SendToProfile(0,'Error '..script..': '..err)
	end
end 
for _,file in pairs(_MYFILES) do
	script_load(file)
end

--account.acl = acl
--account.def_config = def_config
--api.acl = acl
--api.def_config = def_config
tables = require"tables"
util = require"util"
lfs = require"lfs"
if def_config.enable_geoip then
	geoip = require"geoip" -- http://geoip.luaforge.net/
	geoip_flag,geoipdb = pcall(geoip.open,Core.sMainDir.."/geoip/GeoLiteCity.dat") -- http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
end
if def_config.module_bugreport and #def_config.module_bugreport ~= 0 then
	bugreport = require("bugreport."..def_config.module_bugreport)
end

-- ***************************************************************************
function OnStartup()
	botname = Config.sHubBot
	start_time = os.time()
	_NAME__ = Core.GetScript().sName
	commands_loader() -- Load my commands
	pluggin_loader()
	--get_country_code()
	Core.SendToAll(def_config["autosaveinterval"]*60000)
	local res,err=Core.AddTimer(1,def_config["autosaveinterval"]*60000, "api_save_all")
	if res then
		Core.SendToAll("OK"..res)
	else Core.SendToAll("Err "..err)
	end
	print(api:get_lang_string(52):format(def_config.security.password_max_len))
end

function commands_loader() -- Load commands
	local commandspath = _MYCFGDIR.."/commands/"
	local bool,err = false,''
	for file in lfs.dir(commandspath) do
		if file ~= "." and file ~= ".." then
			local _,_, command_file_name, ext = file:find("^(.+)(%.lua)$")
			if command_file_name and not def_config.command_loader.ignore[command_file_name:lower()] then
				if ext then
					local fullpath = commandspath..file
					local attr = lfs.attributes(fullpath)
					if attr.mode ~= "directory" then
						bool,err = pcall(dofile, fullpath)
						if bool then
							if not command then
								api:send_to_hub_owners(fullpath.." is not command file or contains a design errors.")
							end
							def_commands[command_file_name:lower()] = command
							if command and types:is_funcion(command.onload) then
								command.onload()
							end
							command = nil -- remove command from global environment
							print("Loaded command "..fullpath.." & registred as "..command_file_name:lower())
						else 
							api:send_to_hub_owners("Unable to load command "..fullpath..": "..err)
							print("Unable to load command "..fullpath..": "..err)
						end
					end
				end
			end
		end
	end
	collectgarbage("collect")
end


function pluggin_loader()

	local pluggins_path = _MYCFGDIR.."/plugin/"
	for d in lfs.dir(pluggins_path) do
		if d ~= '.' and d ~= '..' then
			path = pluggins_path..d
			attr = lfs.attributes(path)
			if attr.mode == 'directory' then
				local res, err = pcall(dofile,path..'/manifest.lua')
				if not res then
					api:send_to_hub_owners('Error: '..path..'/manifest.lua')
				else
					plugin_events[manifest.__name__]={}
					for i,v in pairs(manifest.files) do 
						if type(manifest.files) == 'table' then
							if api:plugin_events_validator(v) then
								local res, f_ = pcall(dofile,path..'/'..v)
								if not res then
									api:send_to_hub_owners('Error in '..v..':'..f_)
								else 
									plugin_events[manifest.__name__][v:match('^(%S+)%.lua$')]=f_							
									if type(plugin_events[manifest.__name__]) == 'table' and type(plugin_events[manifest.__name__].OnThisIsLoad) == 'function' then
										plugin_events[manifest.__name__].OnThisIsLoad(manifest.__name__)
									end
									collectgarbage('collect')
								end
							end
							--print(tables.SerializeToString(plugin_events))
			
							--print(err)
						end
					end
				end 
			end
		end
	end
end

function OnValidateNick(UID, sData)
	
	local nick = UID.sNick
	local current_account = account:get(nick)
	local profilenum = -1
	if filter:nick_chars(nick) then 
		Core.SendToUser(UID, lang[53], botname)
		Core.Disconnect(UID)
	end
	if current_account then
			profilenum = current_account.iprofile
	end
	if current_account and not current_account.bindip == UID.sIP then
		Core.SendToUser(UID, lang[93], botname)
		Core.DisconnectIP(UID.sIP)
	end
	UID.bInOpList = acl[profilenum].haskey and acl[profilenum].haskey or false
	UID.bInIpList = acl[profilenum].iplist and acl[profilenum].iplist or false
	UID.bKick = acl[profilenum].kick and acl[profilenum].kick or false
	UID.bRedirect = acl[profilenum].redirect and acl[profilenum].redirect or false
	UID.bHide = acl[profilenum].hide and acl[profilenum].hide or false 
	if current_account ~= nil then
		Core.SendToUser(UID, lang[49]:format(UID.sNick), botname)
		return true
	end
end

function OnMyPass(UID, sData)
	local rcvpass = sData:match "^.- (%S+)$" 
	local nick = UID.sNick
	local current_account = account:get(nick)
	if not rcvpass or not rcvpass == current_account.password then
		for i,v in pairs(plugin_events) do 
			if type(plugin_events[i]) == 'table' and type(plugin_events[i].OnBadPass) == 'function' then
				res = plugin_events[i].OnBadPass(i, UID, current_account)
				if util.is_true(res) then
					break
				end
			end
		end
		if not util.is_true(res) then
			Core.SendToUser(UID, lang[57], botname) 
			Core.SendToUser(UID, "$BadPass")
			Core.Disconnect(UID)
		end
	else
		UID.iProfile = current_account.iprofile
		--print(tables.SerializeToString(plugin_events))
		for i,v in pairs(plugin_events) do
			if type(plugin_events[i]) == 'table' and type(plugin_events[i].OnSuccessAuth) == 'function' then
				plugin_events[i].OnSuccessAuth(i, UID, current_account) -- Событие успешной аутентификации пользователя
			end
		end
		if current_account.last_session_time then
			current_account.last_session_time = os.time()
			current_account.last_ip = UID.sIP
			api:save("accounts")
		end
	end
end


function OnUserEnter(UID)
	filter:check_login_limits(UID)
	local ban = bans["ips"] and bans["ips"][UID.sIP]
	if ban then
		local msg=""
		if not ban.expires then -- Перманентный бан.
			msg=msg.."\r\nВы были на всегда забанены на этом хабе"..(ban.sreason and " по причине: "..ban.sreason)..". "
		else 
			msg = msg.."\r\nВы были временно забанены на этом хабе"..(ban.sreason and " по причине: "..ban.sreason)..". Бан истекает через "..util.convert_seconds_to_normal_time(ban.expires - os.time())
		end
		Core.SendToUser(UID, msg..(def_config.security.banmsg or ""), botname)
		Core.Disconnect(UID)
	end
end

-- Handler data in chat.
function OnChat(UID, sData)
	if def_config.block_spaces_before_cmds and sData:find("^%b<>%s%s+(%p)(%S+)") then 
		Core.SendToUser(UID, lang[102], botname)
		return 1 -- block!
	end
	local prefix, cmd = sData:match("^%b<>%s(%p)(%S+)")
	if def_config.enable_command_aliases and command_aliases[cmd] then 
		cmd = command_aliases[cmd] or cmd
	end
	if prefix and cmd and def_config.allow_prefix[prefix] and def_commands[cmd] then		
		sData = sData:match("^%b<>%s%p%S+%s+(.+)")
		local aclbool, acl_reason = def_commands[cmd]["acl"](UID, cmd)
		if aclbool then 
			local res, msg = def_commands[cmd][(sData and sData:find("^%-[Hh]$")) and "man" or "cmd"](UID, cmd, sData)
			if res then
				Core.SendToUser(UID, msg, botname)
				api:send_to_hub_owners("["..UID.iProfile.."] IP: "..UID.sIP.." <"..UID.sNick.."> [Mainchat] Command successful: "..prefix..cmd.." "..(sData and sData or ""),true)
			end
			collectgarbage("collect")
		else
			Core.SendToUser(UID, acl_reason, botname)
			api:send_to_hub_owners("["..UID.iProfile.."] IP: "..UID.sIP.." <"..UID.sNick.."> [Mainchat] Command failed, no permission: "..prefix..cmd.." "..(sData and sData or ""), true)
		end
		return 1
	end
end

-- Handler data in PM.
function OnTo(UID, sData)
	local to = sData:match("^%$To:%s(%S+)")
	if to and to == botname then --/* Обработка команд в привате бота 
		local prefix,cmd = sData:match("^%$To:%s%S+%sFrom:%s%S+%s%$%b<>%s+(%p)(%S+)")
		if def_config.enable_command_aliases and command_aliases[cmd] then 
			cmd = command_aliases[cmd] -- or cmd		
		end
		if prefix and cmd and def_config.allow_prefix[prefix] and def_commands[cmd] then
			sData = sData:match("^%$To:%s%S+%sFrom:%s%S+%s%$%b<>%s+%p%S+%s+(.+)")
			local aclbool, acl_reason = def_commands[cmd]["acl"](UID, cmd) -- is allowed?
			if aclbool then
				local res, msg = def_commands[cmd][(sData and sData:find("^%-[Hh]$")) and "man" or "cmd"](UID, cmd, sData)
				if res then
					api:send_to_ops("["..UID.iProfile.."] IP: "..UID.sIP.." <"..UID.sNick.."> [PM] Command successful: "..prefix..cmd.." "..(sData and sData or ""),true)
					Core.SendToUser(UID, msg, to, botname)
				end
				collectgarbage("collect")
			else
				api:send_to_hub_owners("["..UID.iProfile.."] IP: "..UID.sIP.." <"..UID.sNick.."> [PM] Command failed, no permission: "..prefix..cmd.." "..(sData and sData or ""), true)
				Core.SendToUser(UID,acl_reason,to,botname)
			end
		return 1
		else
			Core.SendToUser(UID, "[mybot] Unknown command", to, botname)
			return 1
		end
	end	-- Обработка команд в привате бота */
end

function OnConfigChange(sName, sValue)
	if sName == "sHubBot" then
		botname = sValue
	end
	if sName == "sLang" then
		lang_file = Config.sLangPath.."scripts/"..sValue.."/mybot.lang"
		local res,err = pcall(dofile,lang_file)
		if not res then
			error(err)
		end
	end
end

function OnExit()
 
end

function OnError(msg)
	api:send_to_hub_owners(msg,botname)
	print(s) -- if hub is not a daemon, show errors in console. It only for debug.
	if def_config.module_bugreport then
		bugreport.bugreport_send(("%s\r\nDate: %s\r\nVersion: %s\r\nHubVersion: %s\r\nLuaPluginVersion: %s\r\nOS: %s\r\nError:\r\n%s"):format(_NAME__, os.date("%X %x"), _MYVERSION, Core.sHubVersion, Core.sLuaPluginVersion, Core.sSystem, msg))
	end
	return true  -- Don't stop the script at runtime errors. IT IS DANGER!!! But we can lose control. :(
end
