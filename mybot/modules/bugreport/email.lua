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
local require, pairs = require, pairs
module(...)
local smtp = require("socket.smtp")
local socket = require("socket")

 
local function getfqdn()
    local hostname = socket.dns.gethostname()
    local _, resolver = socket.dns.toip(hostname)
    local fqdn
    for _, v in pairs(resolver.ip) do
        fqdn, _ = socket.dns.tohostname(v)
        if fqdn:find('%w+%.%w+') then break end
    end
    return fqdn
end

local from = "myBot Bugreport Module <mybot@"..(getfqdn() and getfqdn() or "localhost.localdomain")..">"
local rcpt = {"<admin@saymon21-root.pro>",}


function bugreport_send(msg) 
	local mesgt = {
		headers = {to = "Developers Hub21.ru <admin@saymon21-root.pro>",subject = "myBot Bug Report"},
		body = msg
		}
 
	local r, e = smtp.send{
	  from = from,
	  rcpt = rcpt, 
	  source = smtp.message(mesgt)
	}

	if e then
		print(e)
	end
end


