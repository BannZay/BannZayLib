local BannZayLib = LibStub:GetLibrary("BannZayLib-1.0");
if BannZayLib.Initialized then return; end

local globalSettings = 
{
	MinimumLogLevelOverride = nil;
};

BannZayLib.Namespace:Register("GlobalSettings", globalSettings, false, BannZayLib);
