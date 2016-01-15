

types = {
	is_string = function(self,data)
		if type(data) == "string" then
			return true
		end
	end,
	
	is_array = function (self,data)
		if type(data) == "table" then
			return true
		end
	end,
	
	is_number = function (self,data)
		if type(data) == "number" then
			return true
		end
	end,
	
	is_funcion = function (self,data)
		if type(data) == "function" then
			return true
		end
	end,
	
--	is_in_array = function(self,data, array)
--		if self:is_array(array) then
--			if array[data] then
--				return true
--			end
--		end
--	end,
	
	is_bool = function (self,data)
		if type(data) == "boolean" then
			return true
		end
	end,
	
	is_in_array = function (self, array, what)
		if not self:is_array(array) then
			return nil
		end
		local res = nil
		for i,v in pairs(array) do
			if (v == what) then
				res = true
				break
			end
		end
		return res
	end,
}
