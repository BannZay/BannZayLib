local BannZayLib = LibStub:GetLibrary("BannZayLib-1.0");
if BannZayLib.Initialized then return; end

local GlobalSettings = BannZayLib.GlobalSettings;

local Logger = BannZayLib.Namespace:Register("Logger", BannZayLib.Prototype:NewChild(), false, BannZayLib);


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


function Logger:LogVariable(level, variable, value)
	self:Log(level, "[" .. variable .. "] = '"..value.."'.")
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
