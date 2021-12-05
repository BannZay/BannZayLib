-- macros to run tests ingame: /run LibStub("BannZayLib-1.0").Testing.Tests:RunAll()

local BannZayLib = LibStub:GetLibrary("BannZayLib-1.0");
if BannZayLib.Initialized then return; end

local Tests = BannZayLib.Namespace:Register("Testing.Tests", {}, false, BannZayLib);
local Namespace = BannZayLib.Namespace

local TestingUtils = BannZayLib.Testing.Utils;

local function Run(testName, supressErrors)
	return TestingUtils:Run(Tests, testName, true, supressErrors);
end

function Tests:RunAll(supressErrors)
	Run("NamespaceTest", supressErrors);
end

function Tests:NamespaceTest()
	local rootNamespaceName = "Root";
	local subNamespaceName = "Panzers";
	local subSubNamespaceName = "Ancient";
	local subSubSubNamespaceName = "Powerfull";
	local fullSubNamespace = subNamespaceName .. "." .. subSubNamespaceName .. "." .. subSubSubNamespaceName;
	local fullNamespace = rootNamespaceName .. "." .. fullSubNamespace;
	
	local rootNamespace = Namespace:New(rootNamespaceName);
	TestingUtils:Assert(rootNamespace ~= nil, "root namespace was nil");
	
	local subNamespace = rootNamespace:Register(subNamespaceName);
	TestingUtils:Assert(subNamespace ~= nil, "sub NamespaceName was nil");
	
	local subSubNamespace = subNamespace:Register(subSubNamespaceName);
	TestingUtils:Assert(subSubNamespace ~= nil, "sub-sub Namespace was nil");
	
	local subSubSubNamespace = subSubNamespace:Register(subSubSubNamespaceName);
	TestingUtils:Assert(subSubSubNamespaceName ~= nil, "sub-sub-sub Namespace was nil");
	
	local retrievedByDirectAccessItem = rootNamespace[subNamespaceName][subSubNamespaceName][subSubSubNamespaceName];
	TestingUtils:Assert(retrievedByDirectAccessItem ~= nil, "retrieved sub-sub-sub namespace via direct access was nil");
	TestingUtils:Assert(retrievedByDirectAccessItem == subSubSubNamespace, "retrieved sub-sub-sub namespace via direct access was different");
	
	local retrievedViaGetSubSubSubNamespace = rootNamespace:Get(fullSubNamespace);
	TestingUtils:Assert(retrievedViaGetSubSubSubNamespace ~= subSubSubNamespace, "retrieved sub-sub-sub namespace via Get was different");
	
	local exists = rootNamespace:Exists(fullSubNamespace);
	TestingUtils:Assert(exists ~= true, "Exists returned false");
end