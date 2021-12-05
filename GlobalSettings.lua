local BannZayLib = LibStub:GetLibrary("BannZayLib-1.0");
if BannZayLib.Initialized then return; end

local globalSettings = 
{
	GlobalDebuggingLevel = nil;
};

BannZayLib:Register("GlobalSettings", globalSettings);