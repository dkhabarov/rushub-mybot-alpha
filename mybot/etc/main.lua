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
-- SETTINGS:
def_config = {
--	database = {
--		name = "rushubdev",
--		host = "localhost",
--		port = "3306",
--		user = "root",
--		password = "256325632563",
--		prefix = "dev_",
--	},
	["module_bugreport"] = "email", -- �������� runtime ������ �� email. ������������ �����������������... ��� ������� ����� �������������� ����������� �����.
	["allow_prefix"] = {["!"]=true, ["+"]=true}, -- ����������� ����������� ��������� ��� ������. 
	["allow_chars_in_nicks"] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789()[]{}_-+=.�����Ũ������������������������������������������������������������������,��@=#^~/\\'�*&!�����", -- ����������� ������� � �����.
	["default_profile"] = 3, -- ������� ����������� ������ �� ���������.
	["security"] = {
		["password_min_len"] = 4, -- ����������� ����� ������
		["password_max_len"] = 30, -- ������������ ����� ������
		["banmsg"] = "\r\n�������� ������ �� ����������� �� ���������������!\r\n������ �� ������ ����� ����������� � /dev/null", -- �������������� ���������, ������� ����� �������� ��� ����� ����������.
	},
	["hub_owners"] = {["Saymon"] = true,}, -- ��������� ����. �� ��� ���� ����� ��������� ��������� ������, ���� ��� ���������.
	["command_loader"] = { -- ��������� ���������� ������.
		["ignore"] = {["testcommand1"]=true, ["buildcmddocs"] = true}, -- �������, ������� �� ����� ���������.
	},
	["welcome_new_registred_users_in_main_chat"] = true, -- ���������� ����������� � ��� ��� ���� ����� ����������������� ������.
	["rules"] = {
		["min_share_register"] = 0,--1073741824, -- ����������� ���� ��� �����������. �� ��������� 1GB.
		["max_ip_session"] = 1, -- ������������ ����� ������ � ������ IP-������.
		--["min_share"] = 0, -- ����������� ���� ��� ������� �� ���. �� ��������� 0.
		--["max_share"] = 0, -- ������������ ���� ��� ������� �� ���. �� ��������� 100.044 TB.
		--["min_slots"] = 0, -- ����������� ����� ������ ��� ������� �� ���. �� ��������� 0.
		--["max_slots"] = 1000, -- ������������ ����� ������ ��� ������� �� ���. �� ��������� 1000.
		--["max_hubs"] = 1000, -- ������������ ����� �����.
		["hub_only_reg_users"] = false, -- ��� ������ ��� ����������������� ������.
	},
	["enable_command_aliases"] = true, -- �������� ����� ������.
	["block_spaces_before_cmds"] = true, -- ����������� ��� �������, ���������� �� ���� ����� ��� ����� ��������
	["default_ban_time"] = "1h",
	["autosaveinterval"] = 5,

}
