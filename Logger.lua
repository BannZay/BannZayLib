if not BannZay_Upgrade then return; end

local Logger = Namespace:RegisterGlobal("BannZay.Logger", Prototype:NewChild());

function Logger:New(title, logLevel)
	return self:NewChild({ title = title, logLevel = logLevel });
end

function Logger:Log(level, message)
	local logLevel = self.logLevel or Logger.defaultlogLevel or 0;
	
	if logLevel >= level then
		print("Debug: ", self.title, " - ", message);
	end
end

function Logger:SetLogLevel(level)
	Logger.defaultlogLevel = level;
end