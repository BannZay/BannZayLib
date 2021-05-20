if not BannZay_Upgrade then return; end

local Test = Namespace:RegisterGlobal("BannZay.Testing.Test");

function Test:Throws(func, message)
	if pcall(func) then
		error(message);
	end
end