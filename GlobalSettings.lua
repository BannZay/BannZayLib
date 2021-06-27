if not BannZay_Upgrade then return; end

local globalSettings = 
{
	GlobalDebuggingLevel = nil;
};

local GlobalSettings = Namespace:RegisterGlobal("BannZay.GlobalSettings", globalSettings);