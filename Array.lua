local BannZayLib = LibStub:GetLibrary("BannZayLib-1.0");
if BannZayLib.Initialized then return; end

local log = BannZayLib.Logger:New("Array");

local ArrayProto = BannZayLib.Prototype:NewChild();
local Array = BannZayLib.Namespace:Register("Array", {}, false, BannZayLib);

function Array:New(comparer)
	if comparer == nil then
		comparer = function(x, y) return x == y end;
	end

	return ArrayProto:NewChild({
		count = 0,
		innerList = {},
		comparer = comparer,
	});
end

function ArrayProto:Count()
	return self.count;
end

function ArrayProto:Get(index)
	return self.innerList[index];
end

function ArrayProto:Add(...)
	local arg = {...}
	for i,item in ipairs(arg) do
		if item ~= nil then
			self.count = self.count + 1;
			self.innerList[self.count] = item;
			log:Log(1, "item added: at index " .. self.count);
		end
	end
end

function ArrayProto:All()
	return self.innerList;
end

function ArrayProto:IndexOf(item)
	if item == nil then
		error("item was nil")
	end
	
	log:Log(3, "requested index of item: " .. item)
	
	for i=1, self.count, 1 do
		if (self.comparer(item, self.innerList[i])) then
			log:Log(3, "found index of item: " .. i)
			return i
		end
	end
	
	log:Log(3, "index of item was not found")
	return nil;
end

function ArrayProto:Contains(item)
	return self:IndexOf(item) ~= nil;
end

function ArrayProto:RemoveAt(index)
	local array = self.innerList

	if array[index] ~= nil then
		array[index] = nil;
		
		for i = index, self.count, 1 do
			array[i] = array[i+1];
		end
		
		self.count = self.count - 1;
		
		log:Log(1, "item removed at index: " .. index)
	end
end

function ArrayProto:Remove(item)
	log:Log(2, "Requested to remove item: " .. item);
	local index = self:IndexOf(item);
	
	if (index ~= nil) then
		self:RemoveAt(index);
	else
		log:Log(2, "No item " .. item .. " fount in the list: ");
	end
end

function ArrayProto:Clear()
	self.innerList = {};
	count = 0;
	log:Log(1, "List was cleared");
end

function ArrayProto:Find(selector)
	for i=1, self.count do
		if (selector(self.innerList[i], self.comparer)) then
			return self.innerList[i], i
		end
	end
end

function ArrayProto:TranformAndFind(item, transformer)
	return self:Find(function(listItem, comparer) return comparer(transformer(listItem), item) end)
end

function ArrayProto:ForEach(func)
	for i=1, self.count, 1 do
		if (self.innerList[i]) then
			func(self.innerList[i])
		end
	end
end

function ArrayProto:Transform(func)
	local newArray = Array:New();
	
	for i=1, self.count do
		if (self.innerList[i]) then
			local transformed = func(self.innerList[i]);
			
			if transformed ~= nil then
				newArray:Add(transformed);
			end
		end
	end
	
	return newArray;
end