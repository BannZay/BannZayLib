local BannZayLib = LibStub:GetLibrary("BannZayLib-1.0");
if BannZayLib.Initialized then return; end

local SlashCommandManager = BannZayLib:Register("SlashCommandManager");

local GlobalSettings = BannZayLib.GlobalSettings;
local Logger = BannZayLib.Logger;
local Array = BannZayLib.Array;
local KVP = BannZayLib.KVP;

local log = Logger:New("SlashCommanderDebugger");

local SlashCommander = BannZayLib.Prototype:NewChild();

local function SetIgnoreCase(self, ignoreCase)
	if ignoreCase == true then
		self.commands.comparer = function(x, y) return x:upper() == y:upper() end
	else
		self.commands.comparer = function(x, y) return x == y end
	end
end

local function ParseInput(input)
	local index = input:find(" ");
	
	local command = nil;
	local arguments = nil;
	
	if index ~= nil then
		command = input:sub(0, index-1);
		arguments = input:sub(index+1);
	else
		command = input;
	end
	
	return command, arguments;
end

local function ResolveCommandHandler(slashCommander, command)
	local commandInfo = slashCommander.commands:TranformAndFind(command, function(item) return item:Item1(); end) -- find by name
	local commandHandler;
	if commandInfo == nil then
		log:Log(2, "No command found, default handler will be used")
		commandHandler = slashCommander.missingCommandHandler;
	else
		commandHandler = commandInfo:Item2();
	end
	
	return commandHandler;
end

local function HandleInput(slashCommander, input)
	log:Log(2, "Trying to resolve handler for input '" .. input .. "'")
	local command, arguments = ParseInput(input);
	log:Log(3, "Received command - '" .. (input or "") .. "' with arguments - '" .. (arguments or "") .. "'")
	local commandHandler = ResolveCommandHandler(slashCommander, command);
	log:Log(2, "Handler resolved");
	commandHandler(slashCommander, arguments, input);
	log:Log(3, "Handler executed");
end

local function DefaultHelpCommandHandler(self, args)
	local str = "";
	
	for k, v in pairs(self.commands:All()) do
		if str ~= "" then
			str = str .. ", ";
		end
		
		str = str .. v:Item1();
	end

	self.outputStream:Out("Available commands: " .. str);
end

local function DefaultMissingCommandHandler(self, args, input)
	if input ~= '' then
		self.outputStream:Out("There is no '" .. input .. "' command");
	end
	
	ResolveCommandHandler(self, 'help')(self, nil, nil); -- execute help command
end

local function ToggleDebugCommandHandler(self, args)
	if GlobalSettings.GlobalDebuggingLevel == nil then
		GlobalSettings.GlobalDebuggingLevel = args or 100;
		log:Log(1, "Debug level set to " .. GlobalSettings.GlobalDebuggingLevel);
	else
		GlobalSettings.GlobalDebuggingLevel = nil;
	end
end

local function NewSlashCommander(name, ...)
	log:Log(3, "New slashCommander created with name - " .. name)
	local slashCommander = SlashCommander:NewChild({
		name = name, 
		commands = Array:New(), 
		entryCount = 0,
		outputStream = Logger:New(name, -1, ""),
	});
	
	slashCommander:SetMissingCommandHandler(DefaultMissingCommandHandler);
	
	SetIgnoreCase(slashCommander, true);
	
	SlashCmdList[name] = function(input) HandleInput(slashCommander, input); end
	
	slashCommander:AddEntry(name);
	
	local params = {...}
	for i=1,#params do
		local additionalName = params[i]
		slashCommander:AddEntry(additionalName);
	end
	
	slashCommander:AddCommand("help", DefaultHelpCommandHandler);
	slashCommander:AddCommand("ToggleDebug", ToggleDebugCommandHandler);
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

function SlashCommandManager:New(addonName, ...)
	return NewSlashCommander(addonName, ...);
end