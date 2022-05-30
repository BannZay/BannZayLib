local BannZayLib = LibStub:GetLibrary("BannZayLib-1.0");
if BannZayLib.Initialized then return; end

BannZayLib.Prototype = {}
BannZayLib.Prototype.__index = BannZayLib.Prototype;

-- -- add multiple ctors support
-- function Prototype:Create(ctor)
	-- prototype = {};
	-- prototype.__index = prototype;
	
	-- if ctor == nil then
		-- ctor = function() return {} end
	-- end
	
	-- function prototype:New(...)
		-- local newItem = ctor(...);
		-- setmetatable(newItem, self);
		-- newItem.__index = newItem;
		-- return newItem;
	-- end
	
	-- return prototype;
-- end


-- add multiple ctors support
function BannZayLib.Prototype:NewChild(newItem)
	if newItem == nil then
		newItem = {};
	end

	newItem.__index = newItem;
	setmetatable(newItem, self);
	return newItem;
end