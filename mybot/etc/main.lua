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
	["module_bugreport"] = "email", -- Отправка runtime ошибок на email. Контролируем работоспособность... Для прочего можно использововать анализаторы логов.
	["allow_prefix"] = {["!"]=true, ["+"]=true}, -- Определение разрешённых префиксов для команд. 
	["allow_chars_in_nicks"] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789()[]{}_-+=.АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмнопрстуфхцчшщъыьэюяЄєЇїЉљЋћ,™®@=#^~/\\'©*&!†•Њњ°", -- Разрешённые символы в никах.
	["default_profile"] = 3, -- Профиль регистрации юзеров по умолчанию.
	["security"] = {
		["password_min_len"] = 4, -- Минимальная длина пароля
		["password_max_len"] = 30, -- Максимальная длина пароля
		["banmsg"] = "\r\nНезнание правил не освобождает от ответственности!\r\nЗаявки на снятие банов отправляйте в /dev/null", -- Дополнительное сообщение, которое будет показано при вроде забаненным.
	},
	["hub_owners"] = {["Saymon"] = true,}, -- Владельцы хаба. На эти ники будут приходить некоторые ошибки, если они возникнут.
	["command_loader"] = { -- Настройки загрузчика команд.
		["ignore"] = {["testcommand1"]=true, ["buildcmddocs"] = true}, -- Команды, которые не нужно загружать.
	},
	["welcome_new_registred_users_in_main_chat"] = true, -- Отправлять приветствие в чат для всех новых зарегистированных юзеров.
	["rules"] = {
		["min_share_register"] = 0,--1073741824, -- Минимальная шара для регистрации. По умолчанию 1GB.
		["max_ip_session"] = 1, -- Максимальное число сессий с одного IP-адреса.
		--["min_share"] = 0, -- Минимальная шара для доступа на хаб. По умолчанию 0.
		--["max_share"] = 0, -- Максимальная шара для доступа на хаб. По умолчанию 100.044 TB.
		--["min_slots"] = 0, -- Минимальное число слотов для доступа на хаб. По умолчанию 0.
		--["max_slots"] = 1000, -- Максимальное число слотов для доступа на хаб. По умолчанию 1000.
		--["max_hubs"] = 1000, -- Максимальное число хабов.
		["hub_only_reg_users"] = false, -- Хаб только для зарегистированных юзеров.
	},
	["enable_command_aliases"] = true, -- Включить алисы команд.
	["block_spaces_before_cmds"] = true, -- Блокировать все команды, отделенные от ника более чем одним пробелом
	["default_ban_time"] = "1h",
	["autosaveinterval"] = 5,

}
