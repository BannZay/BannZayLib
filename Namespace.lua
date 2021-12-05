local BannZayLib = LibStub:GetLibrary("BannZayLib-1.0");
if BannZayLib.Initialized then return; end

local function AddNewNamespace(owner, name)
	if owner == nil then
		error();
	end

	local namespace = BannZayLib.Prototype:NewChild({name = name, isNamespace = true})
	owner[name] = namespace;
	return namespace;
end

AddNewNamespace(BannZayLib, "Namespace");

local function ParseItems(fullNamespace)
	local iterator = fullNamespace:gmatch("[^\.]+");
	local entries = BannZayLib.Utils:ToArray(iterator);
	local namespaceNames, lastName = {unpack(entries, 1, #entries-1)}, entries[#entries];
	return namespaceNames, lastName;
end

function BannZayLib.Namespace:Get(fullName, throwOnMiss)
	local parent = BannZayLib[v];
	
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
	
	return parent[lastParent];
end

function BannZayLib.Namespace:Exists(name)
	return Namespace:Get(name) ~= nil;
end

function BannZayLib.Namespace:Register(name, override)
	if name == nil or name == "" then
		error();
	end
	
	if self[name] ~= nil and override ~= true then
		return existingNamespace;
	end
	
	return AddNewNamespace(self, name)
end

function BannZayLib.Namespace:RegisterGlobal(fullName, item, override, owner)
	if item == nil then
		error()
	end
	
	if owner == nil then
		owner = _G
	end
	
	local parent = owner;
	local names, lastName = ParseItems(fullName);
	
	for _, name in ipairs(names) do
		if parent[name] == nil or override then
			if parent.IsNamespace then
				parent = parent:Register(name, override);
			else 
				parent = AddNewNamespace(parent, name);
			end
		else
			return nil;
		end
    end
	
	if parent[lastName] == nil or override then
		parent[lastName] = item
	else
		return nil;
	end
	
	return item;
end

function BannZayLib:Register(fullName, item, override)
	if item == nil then
		item = self.Prototype:NewChild();
	end

	return self.Namespace:RegisterGlobal(fullName, item, override, self);
end