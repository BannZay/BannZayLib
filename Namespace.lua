if not BannZay_Upgrade then return; end

local function NewNamespacePrototype(name, parent, ownerEntity)
	if name == nil or name == "" then
		error();
	end
	
	if parent == nil then
		parent = Prototype;
	end
	
	local properties = {
		parent = parent,
		name = name,
		isNamespace = true,
		owner = ownerEntity 
	};
	
	local namespace = parent:NewChild(properties);
	
	if parent.name == "NamespaceRoot" then
		_G[name] = namespace;
	else
		parent[name] = namespace;
	end
	
	return namespace;
end

Namespace = NewNamespacePrototype("NamespaceRoot");

local function ParseItems(fullNamespace)
	return fullNamespace:gmatch("[^\.]+");
end

function Namespace:Get(fullName, throwOnMiss)
	local parent = nil;
	
	for v in ParseItems(fullName) do
		if parent == nil then
			parent = _G[v];
		else
			parent = parent[v];
		end

		if parent == nil then
			if throwOnMiss == true then
				error();
			else
				return nil;
			end
		end
	end
	
	return parent;
end

function Namespace:Exists(name)
	return Namespace:Get(name) ~= nil;
end

function Namespace:Register(name, override)
	local existingNamespace = self:Get(name);
	
	if existingNamespace ~= nil and override ~= true then
		return existingNamespace;
	end
	
	return NewNamespacePrototype(name, self);
end

function Namespace:RegisterGlobal(fullName, item, ownerEntity, override)
	local parent = Namespace;
	
	for name in ParseItems(fullName) do
		parent = parent:Register(name, override);
    end
	
	if item == nil then
		item = {};
	end
	
	if parent.parent ~= nil then
		parent.parent[parent.name] = item;
	end
		
	return item;
end