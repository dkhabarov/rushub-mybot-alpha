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

-- �������� �������. �� ���� � ����� ������� ���-�� ���. :)
-- �� ��������� �������� ���� ������� ��������� � /scripts/mybot/etc/main.lua.
-- ��� ������� �����:
-- http://clck.ru/8blyW - ��������� ������������ RusHub
-- http://clck.ru/8blyY - Lua API ������� RusHub
-- http://www.lua.ru/doc/

command = {
		options = { -- ����� �������
			short_description = "�������� �������", -- ������� �������� �������. ����� �������� � +help
			hide_in_help = true, -- true - �� ���������� ������� � ������ ������� +help. ���� �������� �� ��������, ��� ����� ����� ������ ��������, ������� ����� ��������.
		},

		-- ����� ������� � �������
		-- ���� account:check_acl ����� true, ������� ����� ��������.
		-- ��������� ������� ���� ����������� � /scripts/mybot/etc/acl.lua
		["acl"] = function (UID, cmd, sData)
			return account:check_acl(UID, cmd)
		end,
	
		-- ���������� ������� �������.
		-- ������� ������ ���������� true � ������, ������� ����� ��������� ����� � �����.
		["cmd"] = function (UID, cmd, sData) 
			return true, cmd.." is works! :-P"
		end,
		
		-- ������������ � ������� �������. ��� ����� �������� ���� ������� ����� ������� � ���������� -[Hh]
		["man"] = function (UID, cmd, sData)
			return true, "�������� �������, ������� ������� � ".._MYCFGDIR.."/commands/"..cmd..".lua."
		end
} -- ����� 

