if not BannZay_Upgrade then return; end

local KVP = Namespace:RegisterGlobal("BannZay.KVP", Prototype:NewChild());

function KVP:New(item1, item2)
	return KVP:NewChild({
		item1 = item1;
		item2 = item2;
	});
end

function KVP:Item1()
	return self.item1;
end

function KVP:Item2()
	return self.item2;
end