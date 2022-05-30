local BannZayLib = LibStub:GetLibrary("BannZayLib-1.0");
if BannZayLib.Initialized then return; end

local GlobalSettings = BannZayLib.GlobalSettings;

local Logger = BannZayLib.Namespace:Register("Logger", BannZayLib.Prototype:NewChild(), false, BannZayLib);


local function DefaultPrintMethod(message)
	print(message);
end

function Logger:New(title, minimumLogLevel, prescription, printMethod)
	local instance = 
	{
		title = title or "", 
		minimumLogLevel = minimumLogLevel, 
		prescription = prescription or "Debug: ",
		printMethod = printMethod or DefaultPrintMethod
	};
	
	return self:NewChild(instance);
end

function Logger:Log(level, message)
	local minimumLogLevel = self.minimumLogLevel or 0;
	
	if (GlobalSettings.GlobalDebuggingLevel or minimumLogLevel) >= level then
		self:Out(self.prescription .. message);
	end
end


function Logger:LogVariable(level, variable, value)
	self:Log(level, "[" .. variable .. "] = '"..value.."'.")
end

function Logger:Out(message)
	if self.title ~= nil and self.title ~= '' then
		message = self.title .. ": " .. message;
	end
	
	self.printMethod(message);
end

function Logger:SetLogLevel(minimumLogLevel)
	self.minimumLogLevel = minimumLogLevel;
end
