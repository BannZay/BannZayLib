if not BannZay_Upgrade then return; end

local Logger = BannZay.Logger;
local Array = BannZay.Array;
local KVP = BannZay.KVP;

local log = Logger:New("SlashCommander");

local SlashCommander = Prototype:NewChild();

local function SetIgnoreCase(self, ignoreCase)
	if ignoreCase == true then
		self.commands.comparer = function(x, y) return x:upper() == y:upper() end
	else
		self.commands.comparer = function(x, y) return x == y end
	end
end

local function HandleInput(slashCommander, input)
	log:Log(2, "Trying to resolve handler for input '" .. input .. "'")
	local commandInfo = slashCommander.commands:TranformAndFind(input, function(item) return item:Item1(); end) -- find by name

	if commandInfo == nil then
		slashCommander.missingCommandHandler(input);
		return
	end

	local command = commandInfo:Item2();
	log:Log(2, "Handler resolved. Executing...");
	command();
end

local function NewSlashCommander(name)
	log:Log(3, "New slashCommander created with name - " .. name)
	local slashCommander = SlashCommander:NewChild({
	name = name, 
	commands = Array:New(), 
	entryCount = 0,
	});
	
	slashCommander.missingCommandHandler = function(input) print(slashCommander.name .. " - There is no '" .. input .. "' command") end
	
	SetIgnoreCase(slashCommander, true);
	
	SlashCmdList[name] = function(input) HandleInput(slashCommander, input); end
	return slashCommander;
end

function SlashCommander:SetMissingCommandHandler(missingCommandHandler)
	self.missingCommandHandler = missingCommandHandler
end

function SlashCommander:SetIgnoreCase(ignoreCase)
	SetIgnoreCase(self, ignoreCase);
end

function SlashCommander:AddEntry(entryName)
	self.entryCount = self.entryCount + 1;
	_G["SLASH_" .. self.name .. self.entryCount] = "/" .. entryName;
	log:Log(3, "New entry added '" .. entryName .. "' to " .. self.name .. " (" .. self.entryCount ..") ");
end

function SlashCommander:AddCommand(command, handler)
	self.commands:Add(KVP:New(command, handler));
end

local SlashCommandManager = Namespace:RegisterGlobal("BannZay.SlashCommandManager", Prototype:NewChild());

function SlashCommandManager:New(addonName)
	return NewSlashCommander(addonName);
end