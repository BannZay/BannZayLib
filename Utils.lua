if not BannZay_Upgrade then return; end

local Utils = Namespace:RegisterGlobal("BannZay.Utils");

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