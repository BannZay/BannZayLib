local BannZayLib = LibStub:GetLibrary("BannZayLib-1.0");
if BannZayLib.Initialized then return; end

BannZayLib.Utils = BannZayLib.Prototype:NewChild();
local Utils = BannZayLib.Utils;

function Utils:SafeCall(func)
	if func == nil then
		return;
	end
	
	return func();
end

function Utils:SetMouseMove(frame, allow, onMovingStarted, onMovingEnd)
	if allow == nil then 
		allow = true;
	end

	if allow and frame:IsMovable() ~= true then
		frame:SetScript("OnMouseDown", function(caller, button) caller:StartMoving(); self:SafeCall(onMovingStarted); end)
		frame:SetScript("OnMouseUp", function(caller, button) if button == "LeftButton" then caller:StopMovingOrSizing(); self:SafeCall(onMovingEnd); end end)
		frame:SetMovable(true);
	end
	
	frame:EnableMouse(allow);
end

function Utils:ToArray(iterator)
	local arr = {};
	for v in iterator do
	  arr[#arr + 1] = v;
	end
	return arr;
end

function Utils:SliceArray(sourceArray, splitPoint)
	local array1, array2;
	for i=1, splitPoint do
		array1[i] = sourceArray[i];
	end
	
	for i=splitPoint+1, #array do
		array2[i-splitPoint]=sourceArray[i];
	end
	
	return array1, array2
end

function Utils:SliceIterator(iterator, splitPoint)
	if type(iterator) == 'table' then
		iterator = pairs(iterator);
	end
	
	local slice1 = function() 
		for i=1, splitPoint do
			return iterator(i-1)
		end
	end
	
	local i = splitPoint;
	local slice2 = function()
		local item = iterator(i);
		i = i + 1;
		return item;
	end
	
	return slice1, slice2;
end