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

-- Тестовая команда. На базе её можно сделать что-то своё. :)
-- По умолчанию загрузка этой команды отключена в /scripts/mybot/etc/main.lua.
-- Ещё полезно знать:
-- http://clck.ru/8blyW - Параметры пользователя RusHub
-- http://clck.ru/8blyY - Lua API функции RusHub
-- http://www.lua.ru/doc/

command = {
		options = { -- Опции команды
			short_description = "Тестовая команда", -- Краткое описание команды. Будет показано в +help
			hide_in_help = true, -- true - Не показывать команду в выводе команды +help. Если параметр не определён, или имеет любое другие значение, команда будет показана.
		},

		-- Права доступа к команде
		-- Если account:check_acl вернёт true, команда будет доступна.
		-- Настройки доступа надо производить в /scripts/mybot/etc/acl.lua
		["acl"] = function (UID, cmd, sData)
			return account:check_acl(UID, cmd)
		end,
	
		-- Обработчик текущей команды.
		-- Функция всегда возвращает true и данные, которые нужно отправить юзеру в ответ.
		["cmd"] = function (UID, cmd, sData) 
			return true, cmd.." is works! :-P"
		end,
		
		-- Документация к текущей команде. Она будет показана если команда будет вызвана с параметром -[Hh]
		["man"] = function (UID, cmd, sData)
			return true, "Тестовая команда, которая описана в ".._MYCFGDIR.."/commands/"..cmd..".lua."
		end
} -- Конец 

