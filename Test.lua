local BannZayLib = LibStub:GetLibrary("BannZayLib-1.0");
if BannZayLib.Initialized then return; end
local name = "Testing.Utils";

local Utils = BannZayLib.Namespace:Register(name, BannZayLib.Prototype:NewChild(), false, BannZayLib);
local ErrorOutput = BannZayLib.Logger:New("", -1);

function Utils:Throws(func, message)
	if pcall(func) then
		error(message);
	end
end

function Utils:Assert(condition, errorMessage)
	if condition ~= true then
		error(errorMessage);
	end
end

function Utils:Run(testClass, testName, printSuccess, supressErrors)
	if testClass == nil then
		ErrorOutput:Out("test class was nil");
		return false;
	end
	
	local testDefinition = "'" .. testName .. "'";
	
	if testClass[testName] == nil then
		ErrorOutput:Out(testDefinition .. " was not found");
		return false;
	end
	
	local status, err = pcall(testClass[testName]);

	if not status then
		ErrorOutput:Out(testDefinition.. " failed");

		if not supressErrors then
			error(err)
		end
		
		return false;
	end
	
	if printSuccess then
		ErrorOutput:Out(testDefinition.. " succeeded");
	end
	
	return true;
end