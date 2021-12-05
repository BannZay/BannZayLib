local BannZayLib = LibStub:GetLibrary("BannZayLib-1.0");
if BannZayLib.Initialized then return; end

local Test = BannZayLib.Namespace:Register("Testing.Test", BannZayLib.Prototype:NewChild(), false, BannZayLib);

function Test:Throws(func, message)
	if pcall(func) then
		error(message);
	end
end