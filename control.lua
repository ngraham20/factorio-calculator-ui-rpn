-- control.lua

require("calculator")

-- ----------------------------------------------------------------
function boolstr(bool)
	if bool then 
		return "T"
	else 
		return "F"
	end
end

-- ----------------------------------------------------------------
function debug_print(str)
	if global.marc_debug then
		game.print(str)
	end
end

function __FUNC__() return debug.getinfo(2, 'n').name end

function debug_log(f, str)
	if global.marc_debug then
		game.print(f .. ": " .. str)
	end
end

-- ----------------------------------------------------------------
local function shortcut(event)
	if event.prototype_name == "calcui_4func" then
    	local player = game.players[event.player_index]
    	toggle_calculator(player)
	end
end

-- ----------------------------------------------------------------
-- user has clicked somewhere.  If clicked on any gui item name that starts with "calcui_..."
-- hide the gui
local function on_gui_click(event)
	local event_name = event.element.name
	debug_print("event_name " .. event_name)
	local player = game.players[event.player_index]

	local calcui_prefix = "calcui"
	local possible_marcalc_prefix = string.sub( event_name, 1, string.len(calcui_prefix))
	if possible_marcalc_prefix == calcui_prefix then
		handle_calcui_click(event, player)
		return
	end
end

-- ----------------------------------------------------------------
-- user has confirmed the textfield / Called when a LuaGuiElement is confirmed, for example by pressing Enter in a textfield. 
local function on_gui_confirmed(event)
	player = game.players[event.player_index];
	if event.element.name == "calcui_display" then
		process_equal_key(player)
	end
end

-- ----------------------------------------------------------------
local function on_calcui_command(event)
	if event.parameter == "debug" then
		global.calcui_debug = true
		debug_print("calcui debugging is on")
	elseif event.parameter == "nodebug" then
		debug_print("calcui debugging is off")
		global.calcui_debug = false
	elseif event.parameter == nil then
		game.players[event.player_index].print("please add a parameter")
	else
		game.players[event.player_index].print("unknown calcui parameter: " .. event.parameter)
	end
end

-- ----------------------------------------------------------------
local function on_hotkey_main(event)
	local player = game.players[event.player_index]
	toggle_calculator(player, true)
end

-- ----------------------------------------------------------------
script.on_event( "calcui_hotkey", on_hotkey_main )
script.on_event( defines.events.on_lua_shortcut, shortcut )
script.on_event( defines.events.on_gui_click, on_gui_click)
script.on_event( defines.events.on_gui_confirmed, on_gui_confirmed)
script.on_event( defines.events.on_gui_text_changed, calcui_on_gui_text_changed )
script.on_event( defines.events.on_gui_location_changed, calcui_on_gui_location_changed )
commands.add_command( "calcui", "Calculator UI [ debug | nodebug ] ", on_calcui_command )