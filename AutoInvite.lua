-- BINDING_HEADER_AUTOINVITE = "Auto Invite"
AutoInviteOptions = {};
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

--------------------------------------------------------------------------------------------------
-- Helper functions
--------------------------------------------------------------------------------------------------

function AutoInvite_ChatOptionStatus(option, text)
    local command = string.lower(text)
    AutoInvite_Print(text .. ": " .. AutoInvite_GetOptionBoolText(option));
    AutoInvite_Print(" - Change with /ai " .. command .. " [on | off]");
end

function AutoInvite_DebugEnabled()
    return AutoInviteOptions[Realm][Player][OPTION_DEBUG];
end

function AutoInvite_DisableOption(option)
    AutoInviteOptions[Realm][Player][option] = 0;
    AutoInvite_OptionsChanged();
end

function AutoInvite_EnableOption(option)
    AutoInviteOptions[Realm][Player][option] = 1;
    AutoInvite_OptionsChanged();
end

function AutoInvite_GetOption(option)
    return AutoInviteOptions[Realm][Player][option];
end

function AutoInvite_GetOptionBoolText(option)
    if AutoInviteOptions[Realm][Player][option] == 1 then
        return "|cFF00CC00on|r";
    else
        return "|cFFCC0000off|r";
    end
end

function AutoInvite_Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage(OUTPUT_HEADER .. msg);
end

function AutoInvite_PrintDebug(msg)
    local ok, local debug_enabled = pcall(AutoInvite_DebugEnabled);
    if (not ok) then
        do return end;
    end
    if (debug_enabled ~= 1) then
        do return end;
    end

    DEFAULT_CHAT_FRAME:AddMessage(OUTPUT_HEADER .. " DEBUG " .. msg);
end

--------------------------------------------------------------------------------------------------
-- Events
--------------------------------------------------------------------------------------------------

function AutoInvite_OnLoad()
	this:RegisterEvent("PLAYER_ENTERING_WORLD");

    SlashCmdList["AutoInvite"] = AutoInvite_Command;
    SLASH_AutoInvite1 = "/ainv";
    SLASH_AutoInvite2 = "/ai";
    SLASH_AutoInvite3 = "/autoinvite";
end

function AutoInvite_OnEvent(event)
    AutoInvite_PrintDebug("AutoInvite_OnEvent " .. event);

	if (event == "PLAYER_ENTERING_WORLD") then
		AutoInvite_Initialize();
    elseif (event == "CHAT_MSG_GUILD" or event == "CHAT_MSG_WHISPER") then
        AutoInvite_HandleChatMessage(arg1, arg2);
    end
end

function AutoInvite_HandleChatMessage(msg, msg_player)
    AutoInvite_PrintDebug(msg_player .. " - " .. msg);
end

--------------------------------------------------------------------------------------------------
-- Initialize
--------------------------------------------------------------------------------------------------

function AutoInvite_Initialize()
    AutoInvite_PrintDebug("AutoInvite_Initialize");
	Player = UnitName("player");
	Realm = GetRealmName();
	if AutoInviteOptions == nil then AutoInviteOptions = {} end;
	if (AutoInviteOptions[Realm] == nil) then AutoInviteOptions[Realm] = {} end;
	if (AutoInviteOptions[Realm][Player] == nil) then AutoInviteOptions[Realm][Player] = {} end;
	if (AutoInviteOptions[Realm][Player][OPTION_DEBUG] == nil) then AutoInviteOptions[Realm][Player][OPTION_DEBUG] = 0 end;
	if (AutoInviteOptions[Realm][Player][OPTION_ENABLED] == nil) then AutoInviteOptions[Realm][Player][OPTION_ENABLED] = 0 end;
	if (AutoInviteOptions[Realm][Player][OPTION_MESSAGE] == nil) then AutoInviteOptions[Realm][Player][OPTION_MESSAGE] = DEFAULT_INV_MESSAGE end;
	if (AutoInviteOptions[Realm][Player][OPTION_GUILD_ENABLED] == nil) then AutoInviteOptions[Realm][Player][OPTION_GUILD_ENABLED] = 0 end;
	if (AutoInviteOptions[Realm][Player][OPTION_WHISPER_ENABLED] == nil) then AutoInviteOptions[Realm][Player][OPTION_WHISPER_ENABLED] = 0 end;
	if (AutoInviteOptions[Realm][Player][OPTION_RAID] == nil) then AutoInviteOptions[Realm][Player][OPTION_RAID] = 0 end;
    AutoInvite_PrintDebug("AutoInvite_Initialize DONE");

    AutoInvite_OptionsChanged();

    AutoInvite_Print("loaded. /ai for usage.");
end

--------------------------------------------------------------------------------------------------
-- Command
--------------------------------------------------------------------------------------------------

function AutoInvite_Command(args)
    local args = string.gsub(args, "%s{2,}", "");

    AutoInvite_PrintDebug("AutoInvite_Command '" .. args .. "'");

    if (args == "") then
        AutoInvite_Print("Auto Invite: " .. AutoInvite_GetOptionBoolText(OPTION_ENABLED));
        AutoInvite_Print(" - Change with /ai [on | off]");

        AutoInvite_ChatOptionStatus(OPTION_GUILD_ENABLED, "Guild");

        AutoInvite_ChatOptionStatus(OPTION_WHISPER_ENABLED, "Whisper");

        AutoInvite_Print("Invite message: \"" .. AutoInviteOptions[Realm][Player][OPTION_MESSAGE] .. "\"");
        AutoInvite_Print(" - Change with /ai <message>");
    
    elseif (args == "on") then
        AutoInvite_EnableOption(OPTION_ENABLED);
        AutoInvite_Print("Auto Invite on.")
    elseif (args == "off") then
        AutoInvite_DisableOption(OPTION_ENABLED);
        AutoInvite_Print("Auto Invite off.")

    elseif (args == "guild") then
        AutoInvite_ChatOptionStatus(OPTION_GUILD_ENABLED, "Guild");
    elseif (args == "guild on") then
        AutoInvite_EnableOption(OPTION_GUILD_ENABLED);
        AutoInvite_Print("Guild messages on.")
    elseif (args == "guild off") then
        AutoInvite_DisableOption(OPTION_GUILD_ENABLED);
        AutoInvite_Print("Guild messages off.")

    elseif (args == "whisper") then
        AutoInvite_ChatOptionStatus(OPTION_WHISPER_ENABLED, "Whisper");
    elseif (args == "whisper on") then
        AutoInvite_EnableOption(OPTION_WHISPER_ENABLED);
        AutoInvite_Print("Whispers on.")
    elseif (args == "whisper off") then
        AutoInvite_DisableOption(OPTION_WHISPER_ENABLED);
        AutoInvite_Print("Whispers off.")
    
    elseif (args == "debug") then
        AutoInvite_Print("Debug: " .. AutoInvite_GetOptionBoolText(OPTION_DEBUG));
        AutoInvite_Print(" - Change with /ai debug [on | off]")
    elseif (args == "debug on") then
        AutoInvite_EnableOption(OPTION_DEBUG);
        AutoInvite_Print("Debug on.")
    elseif (args == "debug off") then
        AutoInvite_DisableOption(OPTION_DEBUG);
        AutoInvite_Print("Debug off.")

    else
        AutoInviteOptions[Realm][Player][OPTION_MESSAGE] = args;
        AutoInvite_Print("Updated message: \"" .. AutoInviteOptions[Realm][Player][OPTION_MESSAGE] .. "\"");
    end
end

--------------------------------------------------------------------------------------------------
-- Options updated
--------------------------------------------------------------------------------------------------

function AutoInvite_OptionRegisterOrUnregister(option, event)
    if (AutoInvite_GetOption(option) == 1) then
        AutoInvite_PrintDebug("Registered event: " .. event);
        this:RegisterEvent(event);
    else
        AutoInvite_PrintDebug("Unregistered event: " .. event);
        this:UnregisterEvent(event);
    end
end

function AutoInvite_OptionsChanged()
    if (AutoInvite_GetOption(OPTION_ENABLED) == 1) then
        AutoInvite_OptionRegisterOrUnregister(OPTION_GUILD_ENABLED, "CHAT_MSG_GUILD");
        AutoInvite_OptionRegisterOrUnregister(OPTION_WHISPER_ENABLED, "CHAT_MSG_WHISPER");
    else
        AutoInvite_PrintDebug("Unregistered all events");
        this:UnregisterAllEvents();
    end
end
