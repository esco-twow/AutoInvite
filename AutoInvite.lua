-- BINDING_HEADER_AUTOINVITE = "Auto Invite"
AutoInviteConfig = {};
local Realm;
local Player;

-- local OUTPUT_HEADER = "|cFF51C878 AutoInvite|r ";
-- local OUTPUT_HEADER = "|cFF41A564 AutoInvite|r ";
-- local OUTPUT_HEADER = "|cFF5C9732 AutoInvite|r ";
-- local OUTPUT_HEADER = "|cFF7AC142 AutoInvite|r ";
-- local OUTPUT_HEADER = "|cFF3F7C2E AutoInvite|r ";
local OUTPUT_HEADER = "|cFFCC00FF AutoInvite|r ";

local DEFAULT_INV_MESSAGE = "1";

local OPTION_DEBUG = "Debug";
local OPTION_ENABLED = "Enabled";
local OPTION_MESSAGE = "Message";
local OPTION_GUILD_ENABLED = "Guild_Enabled";
local OPTION_WHISPER_ENABLED = "Whisper_Enabled";
local OPTION_RAID = "Raid";

function AutoInvite_DebugEnabled()
    return AutoInviteConfig[Realm][Player][OPTION_DEBUG];
end

function AutoInvite_PrintDebug(msg)
    -- if (AutoInviteConfig[Realm][Player][OPTION_DEBUG] == nil or AutoInviteConfig[Realm][Player][OPTION_DEBUG] == 0) then

    ok, debug_enabled = pcall(AutoInvite_DebugEnabled);
    if (not ok) then
        do return end;
    end
    if (debug_enabled ~= 1) then
        do return end;
    end

    DEFAULT_CHAT_FRAME:AddMessage(OUTPUT_HEADER .. " DEBUG " .. msg);
end

function AutoInvite_Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage(OUTPUT_HEADER .. msg);
end

function AutoInvite_OnLoad()
    -- this:RegisterEvent("ADDON_LOADED");
    -- this:RegisterEvent("CHAT_MSG_WHISPER");
	this:RegisterEvent("PLAYER_ENTERING_WORLD");

    SlashCmdList["AutoInvite"] = AutoInvite_Command;
    SLASH_AutoInvite1 = "/ainv";
    SLASH_AutoInvite2 = "/ai";
    SLASH_AutoInvite3 = "/autoinvite";

    -- DEFAULT_CHAT_FRAME:AddMessage("AutoInvite loaded /ai for usage.");
    -- print("AutoInvite loaded /ai for usage.")
    -- message("Testing1");
end

function AutoInvite_OnEvent(event)
    AutoInvite_PrintDebug("AutoInvite_OnEvent " .. event);

    -- if (event == "ADDON_LOADED") and (arg1 == "AutoInvite") then
    --     DEFAULT_CHAT_FRAME:AddMessage("Auto Invite loaded, /ainv");
    -- end
	if(event == "PLAYER_ENTERING_WORLD") then
		AutoInvite_InitializeSetup();
    end
end

function AutoInvite_InitializeSetup()
    AutoInvite_PrintDebug("AutoInvite_InitializeSetup");
	Player = UnitName("player");
	Realm = GetRealmName();
	if AutoInviteConfig == nil then AutoInviteConfig = {} end;
	if (AutoInviteConfig[Realm] == nil) then AutoInviteConfig[Realm] = {} end;
	if (AutoInviteConfig[Realm][Player] == nil) then AutoInviteConfig[Realm][Player] = {} end;
	if (AutoInviteConfig[Realm][Player][OPTION_DEBUG] == nil) then AutoInviteConfig[Realm][Player][OPTION_DEBUG] = 0 end;
	if (AutoInviteConfig[Realm][Player][OPTION_ENABLED] == nil) then AutoInviteConfig[Realm][Player][OPTION_ENABLED] = 0 end;
	if (AutoInviteConfig[Realm][Player][OPTION_MESSAGE] == nil) then AutoInviteConfig[Realm][Player][OPTION_MESSAGE] = DEFAULT_INV_MESSAGE end;
	-- if(AutoInviteConfig[Realm][Player]["Type"] == nil) then AutoInviteConfig[Realm][Player]["Type"] = "Party" end;
    -- DEFAULT_CHAT_FRAME:AddMessage("AutoInvite_InitializeSetup DONE", 1, 1, 1);
    AutoInvite_PrintDebug("AutoInvite_InitializeSetup DONE");

    AutoInvite_Print("loaded. /ai for usage.");
end

function AutoInvite_Command(args)
    AutoInvite_PrintDebug("AutoInvite_Command test '" .. args .. "'");
    if (args == "") then
        AutoInvite_PrintDebug("enabled: " .. AutoInviteConfig[Realm][Player][OPTION_ENABLED]);
        AutoInvite_Print("enabled: " .. (AutoInviteConfig[Realm][Player][OPTION_ENABLED] == 0 and "no" or "yes"));
        AutoInvite_Print("invite message: " .. AutoInviteConfig[Realm][Player][OPTION_MESSAGE]);
        AutoInvite_Print("invite message: " .. AutoInviteConfig[Realm][Player][OPTION_MESSAGE]);
    elseif (args == "enable") then
        AutoInvite_PrintDebug("enabled: " .. AutoInviteConfig[Realm][Player][OPTION_ENABLED]);
    elseif (args == "debug") then
        AutoInviteConfig[Realm][Player][OPTION_DEBUG] = 1;
    end
end

-- function pfUI.autoinvite:UpdateConfig()
--     if config.state == "1" then
--       if config.gchat == "1" then
--         pfUI.autoinvite.scanner:RegisterEvent("CHAT_MSG_GUILD")
--       else
--         pfUI.autoinvite.scanner:UnregisterEvent("CHAT_MSG_GUILD")
--       end
  
--       if config.wchat == "1" then
--         pfUI.autoinvite.scanner:RegisterEvent("CHAT_MSG_WHISPER")
--       else
--         pfUI.autoinvite.scanner:UnregisterEvent("CHAT_MSG_WHISPER")
--       end
--     else
--       pfUI.autoinvite.scanner:UnregisterAllEvents()
--     end
--   end
