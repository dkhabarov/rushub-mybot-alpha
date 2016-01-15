-- ***************************************************************************
-- tables - Module for save lua tables to file.
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

local _G = _G
module(...)

function SerializeToString (tTable, sTableName, sTab)
    local tTableConcat = {}
    local sTab = sTab or ""
    _G.table.insert(tTableConcat, sTab)
    _G.table.insert(tTableConcat, sTableName and sTableName.." = {\r\n" or "return {\r\n")
    for key, value in _G.pairs(tTable) do
        local sKey = (_G.type(key) == "string") and ("[%q]"):format(key) or ("[%d]"):format(key)
        if(_G.type(value) == "table") then
            _G.table.insert(tTableConcat, SerializeToString(value, sKey, sTab.."\t"))
        else
            local sValue = (_G.type(value) == "string") and _G.string.format("%q",value) or _G.tostring(value)
            _G.table.insert(tTableConcat, sTab)
            _G.table.insert(tTableConcat, "\t")
            _G.table.insert(tTableConcat, sKey)
            _G.table.insert(tTableConcat, " = ")
            _G.table.insert(tTableConcat, sValue)
        end
        _G.table.insert(tTableConcat, ",\r\n")
    end
    _G.table.insert(tTableConcat, sTab)
    _G.table.insert(tTableConcat, "}")
    return _G.table.concat(tTableConcat)
end

local function Save_Serialize (tTable, sTableName, hFile, sTab)
	sTab = sTab or "";
	hFile:write(sTab..sTableName.." = {\n" )
	for key, value in _G.pairs(tTable) do
		local sKey = (_G.type(key) == "string") and _G.string.format("[%q]",key) or _G.string.format("[%d]",key)
		if(_G.type(value) == "table") then
			Save_Serialize(value, sKey, hFile, sTab.."\t")
		else
			local sValue = (_G.type(value) == "string") and _G.string.format("%q",value) or _G.tostring(value)
			hFile:write( sTab.."\t"..sKey.." = "..sValue)
		end
		hFile:write( ",\n")
	end
	hFile:write( sTab.."}")
end

function Save_File (filename, tTable, tablename)	--// Needs an absolute path
	local hFile, err = _G.io.open (filename , "wb")
	if hFile then
		Save_Serialize( tTable, tablename, hFile)
		hFile:flush()
		hFile:close()
		return true
	else
		return nil, "Can't open '"..filename.."' for writing. Error: "..err
	end
-- 	collectgarbage("collect")
end


--- http://svn.fonosfera.org/fon-ng/trunk/luci/libs/
--- Appends numerically indexed tables or single objects to a given table.
-- @param src	Target table
-- @param ...	Objects to insert
-- @return		Target table
function append (src, ...)
	for i, a in _G.ipairs({...}) do
		if _G.type(a) == "table" then
			for j, v in _G.ipairs(a) do
				src[#src+1] = v
			end
		else
			src[#src+1] = a
		end
	end
	return src
end

function update (t, updates)
	for k, v in _G.pairs(updates) do
		t[k] = v
	end
	return t
end

function is_in_array (array, what)
	if type(array) ~= "table" then
		return nil
	end 
	local res = nil
	for i,v in _G.pairs(array) do
		if (v == what) then
			res = true
			break
		end
	end
	return res
end
