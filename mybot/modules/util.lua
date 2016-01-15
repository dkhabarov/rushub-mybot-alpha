-- ***************************************************************************
-- util - Module with additional functions for my scripts.
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
local _base = _G
module(...)
_VERSION = "0.1"

function convert_bytes_to_normal_size (share)
    local i,unit = 1, {"B","KB","MB","GB","TB","PB","EB"}
    while share > 1024 do 
    	share = share / 1024 i = i + 1 
    end
    return _base.string.format("%.3f",share).." "..(unit[i] or "??")
end

function convert_normal_size_to_bytes (value)
	if value and value ~= "" then
		value = value:lower()
		local t = { ["b"] = 1, ["kb"] = 1024, ["mb"] = 1024^2, ["gb"] = 1024^3, ["tb"] =1024^4, ["pb"] =1024^5}
		local _,_,num = value:find("^(%d+%.*%d*)")
		local _,_,tail = value:find("^%d+%.*%d*%s*(%a+)$")

		if not num then 
			return false 
		end
		num = _base.tonumber(num)
		if not tail then 
			return num 
		end

		local multiplier = 1
		if num and tail and t[tail] then
			multiplier = t[tail]
		elseif not num or (tail and not t[tail]) then
			return false
		end
		return (_base.tonumber(num) * multiplier)
	else
		return false
	end
end

function is_ipv4(str)
	if str:find("^%d+%.%d+%.%d+%.%d+$") then --can do better.
		return true
	end
end

function is_ipv6(s)
	local had_elipsis = false
	local num_chunks = 0
	while s ~= "" do
		num_chunks = num_chunks + 1
		local p1, p2 = s:find("::?")
		local chunk
		if p1 then
			chunk = s:sub(1, p1 - 1)
			s = s:sub(p2 + 1)
			if p2 ~= p1 then
				if had_elipsis then 
					return false 
				end
				had_elipsis = true
				if chunk == "" then 
					num_chunks = num_chunks - 1 
                end
			else
				if chunk == "" then
					return false
				end
				if s == "" then 
					return false
				end
			end
		else
			chunk = s
			s = ""
		end
		-- Chunk is neither 4-digit hex num, nor IPv4address in last chunk.
		if (not chunk:find("^[0-9a-f]+$") or chunk:len() > 4) and (s ~= "" or not is_ipv4(chunk)) and chunk ~= "" then
			return false
		end
		-- IPv4address in last position counts for two chunks of hex digits.
		if chunk:len() > 4 then 
			num_chunks = num_chunks + 1
		end
	end
	if had_elipsis then
		if num_chunks > 7 then 
			return false
		end
	else
		if num_chunks ~= 8 then
			return false 
		end
	end
    return true
end


function is_ip_address(str) 
	if is_ipv4(str) then
		return 4
	elseif is_ipv6(str) then
		return 6
	end
end

function convert_seconds_to_normal_time(s)
	s = _base.tonumber(s) or 0
	local r = ''
	if s >= 31104000 then 
		r =    _base.math.floor(s / 31104000).." г. "   
		s = _base.math.fmod(s, 31104000)
	end
	if s >= 2592000 then 
		r = r.._base.math.floor(s / 2592000 ).." мес. " 
		s = _base.math.fmod(s, 2592000 ) 
	end
	if s >= 86400 then 
		r = r.._base.math.floor(s / 86400   ).." д. "
		s = _base.math.fmod(s, 86400   )
	end
	if s >= 3600 then 
		r = r.._base.math.floor(s / 3600    ).." ч. "
		s = _base.math.fmod(s, 3600    )
	end
	if s >= 60 then
		r = r.._base.math.floor(s / 60      ).." мин. " 
		s = _base.math.fmod(s, 60      ) 
	end
	return r..s.." сек."
end

function convert_to_second (str_time, base) -- TODO: Refactoring
	if str_time and str_time ~= "" then
		local t = { ["H"] = 3600, ["h"] = 3600, 
					["M"] = 3600*720, ["m"] = 60, 
					["D"] = 24*3600, ["d"] = 24*3600, 
					["Y"] = 365*24*3600, ["y"] = 365*24*3600, 
					["w"] = 7*24*3600, ["W"] = 7*24*3600,
					["s"] = 1, ["S"] = 1,
					["ms"]=1/1000, ["MS"] = 1/1000,
				}
		local _,_,num, tail = str_time:find("^(%-?%d+)(%a-)$")
		if num and tail and t[tail] then
			return (_base.tonumber(num) * t[tail])
		elseif num and tail == "" then
			local multiplier = (base and t[base]) or 1
			return _base.tonumber(num*multiplier)
		else
			return false
		end
	else
		return false
	end
end	


function ipv4_to_network_netmask(ip_address_str)
  local octet4, octet3, octet2, octet1, netmask = ip_address_str:match('(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)/(%d%d?)')
  if octet4 and octet3 and octet2 and octet1 and netmask then
    return (2^24*octet4 + 2^16*octet3 + 2^8*octet2 + octet1), _base.tonumber(netmask);
  end
end

function ipv4_network(ip_address, netmask)
  return math.floor(ip_address / 2^(32-netmask));
end

function ipv4_in_network(ip_address, network, netmask)
  return ipv4_network(ip_address, netmask) == ipv4_network(network, netmask);
end


function ip_addr_to_num(ip)
	if is_ip_address(ip) == 4 then
		local octet4, octet3, octet2, octet1 = ip:match"^(%d+)%.(%d+)%.(%d+)%.(%d+)$"
		return 2^24*octet4 + 2^16*octet3 + 2^8*octet2 + octet1
	end
end

function num_to_ip_addr(i)
	local i = _base.tonumber(i) or 0
	local r, d, zd = '', '.', "0."
	if i >= 16777216 then
		r = _base.math.floor(i / 16777216)..d
		i = _base.math.fmod(i, 16777216) 
	else 
		r = zd
	end
	if i >= 65536 then
		r = r.._base.math.floor(i / 65536)..d
		i = _base.math.fmod(i, 65536)
	else
		r = r..zd
	end
	if i >= 256 then
		r = r.._base.math.floor(i / 256)..d
		i = _base.math.fmod(i, 256) 
	else 
		r = r..zd 
	end
  return r..i
end

-- @return boolean, True if the address is reserved per RFC 1918.
function is_private_ip(ip)  -- FIXME
	if not is_ipv4(ip) then
		return nil, "Is not IPv4 address"
	end
	if ip:match('^10%.%d+%.%d+%.%d+$') or -- /8 
			ip:match('^172%.16%.%d+%.%d+$') or -- /12
			ip:match('^192%.168%.%d+%.%d+$') then -- /16
		return true
	end
end

-- @return boolean, True if the address is a loopback per RFC 3330
function is_loopback_ip (ip) -- FIXME
	if not is_ipv4(ip) then
		return nil, "Is not IPv4 address"
	end
	if ip:match("127%.%d+%.%d+%.%d+") then
		return true
	end
end
	


function split(str, pat)
	local t = {}
	local fpat = "(.-)" .. pat
	local last_end = 1
	local s, e, cap = str:find(fpat, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			_base.table.insert(t,cap)
		end
		last_end = e+1
		s, e, cap = str:find(fpat, last_end)
	end
	if last_end <= #str then
		cap = str:sub(last_end)
		_base.table.insert(t, cap)
	end
	return t
end


function is_true(data)
	if data == true or data == 1 then
		return true
	end 
end
