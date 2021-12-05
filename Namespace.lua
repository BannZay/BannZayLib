local BannZayLib = LibStub:GetLibrary("BannZayLib-1.0");
if BannZayLib.Initialized then return; end

BannZayLib.Namespace = {}
local NameSpacePrototype = BannZayLib.Prototype:NewChild();

function BannZayLib.Namespace:New(name)
	return NameSpacePrototype:NewChild({isNamespace = true});
end

local function ParseItems(fullNamespace)
	local iterator = fullNamespace:gmatch("[^\.]+");
	local entries = BannZayLib.Utils:ToArray(iterator);
	local namespaceNames, lastName = {unpack(entries, 1, #entries-1)}, entries[#entries];
	return namespaceNames, lastName;
end

function BannZayLib.Namespace:Register(fullName, item, override, owner)
	if item == nil then
		error()
	end
	
	if owner == nil then
		owner = _G
	end
	
	local parent = owner;
	local names, lastName = ParseItems(fullName);
	
	for _, name in ipairs(names) do
		if parent[name] == nil then
			if parent.IsNamespace then
				parent:Register(name, override);
			else 
				local newNamespace = NameSpacePrototype:NewChild({name = name});
				parent[name] = newNamespace;
			end
		end
		
		parent = parent[name]
    end
	
	if parent[lastName] == nil or override then
		parent[lastName] = item
	else
		return nil;
	end
	
	return item;
end

function NameSpacePrototype:Get(fullName, throwOnMiss)
	local parent = self;
	
	local names, lastName = ParseItems(fullName)
	
	for i=1, #names do
		parent = parent[v];

		if parent == nil then
			if throwOnMiss == true then
				error();
			else
				return nil;
			end
		end
	end
	
	return parent[lastName];
end

function NameSpacePrototype:Exists(name)
	return self:Get(name) ~= nil;
end

function NameSpacePrototype:Register(name, override)
	if name == nil or name == "" then
		error();
	end
	
	if self[name] ~= nil and override ~= true then
		return existingNamespace;
	end

	local namespace =  BannZayLib.Namespace:New(name);
	self[name] = namespace;
	return namespace;
end