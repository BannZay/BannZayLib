if not BannZay_Upgrade then return; end

local GlobalSettings = BannZay.GlobalSettings;

local Logger = Namespace:RegisterGlobal("BannZay.Logger", Prototype:NewChild());

local function DefaultPrintMethod(message)
	print(message);
end

function Logger:New(title, logLevel, prescription, printMethod)
	local instance = 
	{
		title = title or "", 
		logLevel = logLevel, 
		prescription = prescription or "Debug: ",
		printMethod = printMethod or DefaultPrintMethod
	};
	
	return self:NewChild(instance);
end

function Logger:Log(level, message)
	local logLevel = self.logLevel or 0;
	
	if (GlobalSettings.GlobalDebuggingLevel or logLevel) >= level then
		self:Print(self.prescription .. self.title .. ": " .. message);
	end
end

function Logger:Out(message)
	self:Print(self.title .. ": " .. message);
end

function Logger:SetLogLevel(level)
	self.logLevel = level;
end

function Logger:Print(message)
	self.printMethod(message);
end
