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

acl = { -- Definition profiles and acl for commands etc. If you want to prohibit the use of the team, it is enough just commenting.
		[0]= {
			["is_real_operator"] = true, -- ���� ������� ��������
			["haskey"] = true, -- ������������ � ��-�����, �� ���� ����� ������ ���������
			["iplist"] = true, -- ������������ � IP-�����, �� ���� ��� ���������� IP-������ ���� �������������
			["kick"] = true, -- ����������� ��������� � ����
			["redirect"] = false, -- ����������� ��������� � ���������������
			["hide"] = false,  -- ������������ ����� � ������ ������������ �������������
			-- ["root"] = true, -- ����� �������� ��� �������. ������ �������� ����� ������������, ��� ����������� ������ � tcmds. ��� ������������� tcmds �������������� ���� �������� ��� ���������� false.
			["tcmds"] = { -- � ���� ������� ����� ���������� ������ ����������� �������, ������� ����� �������� ������ � ���� ��������.
				-- ["testcommand1"] = true,
				["help"] = true,
				["startscript"] = true,
				["stopscript"] = true,
				["lsscript"] = true,
				["movedownscript"] = true,
				["moveupscript"] = true,
				["restartscript"] = true,
				["rhgetconf"] = true,
				["rhsetconf"] = true,
				["showtopic"] = true,
				["reloadcmds"] = true,
				["regme"] = true,
				["passwd"] = true,
				["rmmyaccount"] = true,
				["bindip"] = true,
				["unbindip"] = true,
				["man"] = true,
				["dropuser"] = true,
				["myip"] = true,
				["banip"] = true,
			},
			["limits"] = {
				["max_ip_session"] = 1,
			}
		},
		[1] = {
			["is_real_operator"] = true,
			["oplist"] = true,
			["iplist"] = true,
			["kick"] = true,
			["redirect"] = false,
			["tcmds"] = {
				["help"] = true,
				["showtopic"] = true,
				["regme"] = true,
				["passwd"] = true,
				["rmmyaccount"] = true,
				["man"] = true,
			},
		},
		[2] = {
			["tcmds"] = {
				["help"] = true,
				["showtopic"] = true,
				["regme"] = true,
				["passwd"] = true,
				["rmmyaccount"] = true,
				["man"] = true,
			},
		},
		[3] = {			
			["tcmds"] = {
				["help"] = true,
				["report"] = true,
				["showtopic"] = true,
				["regme"] = true,
				["passwd"] = true,
				["rmmyaccount"] = true,
				["man"] = true,
				["dropuser"] = true,
			},
		},
		[-1] = {
			["tcmds"] = {
				["help"] = true,
				["report"] = true,
				["showtopic"] = true,
				["regme"] = true,
				["man"] = true,
			},
		},
		
		
	} -- end acl
