if not BannZay_Upgrade then return; end

local log = BannZay.Logger:New("Array");

local Array = Namespace:RegisterGlobal("BannZay.Array", Prototype:NewChild());

function Array:New(comparer)
	return self:NewChild({
		count = 0,
		innerList = {},
		comparer = comparer,
	});
end

function Array:Count()
	return self.count;
end

function Array:Get(index)
	return self.innerList[index];
end

function Array:Add(...)
	local arg = {...}
	for i,item in ipairs(arg) do
		if item ~= nil then
			self.count = self.count + 1;
			self.innerList[self.count] = item;
			log:Log(1, "item added: at index " .. self.count);
		end
	end
end

function Array:All()
	return self.innerList;
end

function Array:IndexOf(item)
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

function Array:RemoveAt(index)
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

function Array:Remove(item)
	log:Log(2, "Requested to remove item: " .. item);
	local index = self:IndexOf(item);
	
	if (index ~= nil) then
		self:RemoveAt(index);
	else
		log:Log(2, "No item " .. item .. " fount in the list: ");
	end
end

function Array:Clear()
	self.innerList = {};
	count = 0;
	log:Log(1, "List was cleared");
end

function Array:Find(selector)
	for i=1, self.count do
		if (selector(self.innerList[i], self.comparer)) then
			return self.innerList[i], i
		end
	end
end

function Array:TranformAndFind(item, transformer)
	return self:Find(function(listItem, comparer) return comparer(transformer(listItem), item) end)
end

function Array:ForEach(func)
	for i=1, self.count, 1 do
		if (self.innerList[i]) then
			func(self.innerList[i])
		end
	end
end