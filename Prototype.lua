if not BannZay_Upgrade then return; end

Prototype = {}
Prototype.__index = Prototype;

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
function Prototype:NewChild(newItem)
	if newItem == nil then
		newItem = {};
	end

	setmetatable(newItem, self);
	newItem.__index = newItem;
	return newItem;
end