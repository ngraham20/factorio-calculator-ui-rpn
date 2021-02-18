-- calculator.lua

-- ----------------------------------------------------------------
local function get_gui_root(player)
	return player.gui.screen
end

local nilaus_think = { "calcui_nilaus_really" }
local nilaus_rant = { "calcui_nilaus_ugghhhh", "utility/cannot_build" }

-- ----------------------------------------------------------------
local function play_sfx(player, sfx)
	if settings.get_player_settings(player)["calcui-sfx"].value then
		player.play_sound{
			path = sfx,
			volume_modifier = 1.0
		}
	end
end

-- ----------------------------------------------------------------
local function show_think(player, enabled)
	local root = get_gui_root(player)
	local col2 = root.calcui.calcui_table.calcui_table_col2

	if enabled then
		if settings.get_player_settings(player)["calcui-nilaus-mode"].value then
			col2.calcui_rant.sprite = "sprite_calcui_think"
			col2.calcui_scroll_pane.style.height = 196
			play_sfx(player, nilaus_think[math.random(1, #nilaus_think)])
		else
			play_sfx(player, "calcui_home_improvement")
		end
	else
		col2.calcui_rant.sprite = nil
		col2.calcui_scroll_pane.style.height = 252
	end
end

-- ----------------------------------------------------------------
local function show_rant(player, enabled)
	local root = get_gui_root(player)
	local col2 = root.calcui.calcui_table.calcui_table_col2

	if enabled then
		if settings.get_player_settings(player)["calcui-nilaus-mode"].value then
			col2.calcui_rant.sprite = "sprite_calcui_rant"
			col2.calcui_scroll_pane.style.height = 196
			play_sfx(player, nilaus_rant[math.random(1, #nilaus_rant)])
		else
			play_sfx(player, "utility/cannot_build")
		end
	else
		col2.calcui_rant.sprite = nil
		col2.calcui_scroll_pane.style.height = 252
	end
end

-- ----------------------------------------------------------------
local function destroy_calculator(player)
	local root = get_gui_root(player)
	if root.calcui then
		root.calcui.destroy()
		global.recent_results[player.index] = {}
	end
end

-- ----------------------------------------------------------------
local function fix_oob_ui(player)
	if global.gui_position[player.index].x < 0 then
		global.gui_position[player.index].x = 0
	end
	if global.gui_position[player.index].y < 0 then
		global.gui_position[player.index].y = 0
	end

	-- TODO fixed box size, because there is no API call for that
	local width = 255
	local height = 350

	if global.gui_position[player.index].x + width > player.display_resolution.width then
		global.gui_position[player.index].x = player.display_resolution.width - width
	end
	if global.gui_position[player.index].y + height > player.display_resolution.height then
		global.gui_position[player.index].y = player.display_resolution.height - height
	end
end

-- ----------------------------------------------------------------
function show_calculator(player)
	local root = get_gui_root(player)

	if not global.recent_results then
		global.recent_results = {}
	end
	if not global.recent_results[player.index] then
		global.recent_results[player.index] = {}
	end

	if not root.calcui then
		local calcui = root.add({
			type = "frame",
			name = "calcui",
			direction = "vertical"
		})

		local flow = calcui.add({
			type = "flow",
			name = "calcui_flow"
		})
		flow.style.horizontally_stretchable = "on"

		flow.add({
			type = "label",
			name = "calcui_title",
			caption = {"calculator-ui.title"},
			style = "frame_title"
		}).drag_target = calcui

		local widget = flow.add({
			type = "empty-widget",
			style = "draggable_space_header",
			name = "calcui_drag"
		})
		widget.drag_target = calcui
		widget.style.horizontally_stretchable = "on"
		widget.style.minimal_width = 24
		widget.style.natural_height = 24

		flow.add({
			type = "sprite-button",
			sprite = "utility/close_white",
			style = "frame_action_button",
			name = "calcui_close"
		})

		local table = calcui.add({
			type = "table",
			name = "calcui_table",
			column_count = "2",
			vertical_centering = "false"
		})

		local col1 = table.add({
			type = "flow",
			name = "calcui_table_col1",
			direction = "vertical"
		})

		local display = col1.add({
			type = "textfield",
			caption = "",
			name = "calcui_display"
		})
		display.style.width = 212

		local row1 = col1.add({type="flow", name="calcui_col1_row1", direction="horizontal"})
		row1.add({type="sprite-button", style="calcui_button_style_light", caption="CE", name="calcui_button_CE"}).sprite = "sprite_calcui_light"		-- CE = Clear Entry (just this line)
		row1.add({type="sprite-button", style="calcui_button_style_light", caption="C",  name="calcui_button_C"}).sprite = "sprite_calcui_light"		-- C  = Clear (all, past results as well)
		row1.add({type="sprite-button", style="calcui_button_style_light", caption="",   name="calcui_button_BS"}).sprite = "sprite_calcui_backspace"
		row1.add({type="sprite-button", style="calcui_button_style_light", caption="/",  name="calcui_button_DIV"}).sprite = "sprite_calcui_light"

		local row2 = col1.add({type="flow", name="calcui_col1_row2", direction="horizontal"})
		row2.add({type="sprite-button", style="calcui_button_style_dark",  caption="7",  name="calcui_button_7"}).sprite = "sprite_calcui_dark"
		row2.add({type="sprite-button", style="calcui_button_style_dark",  caption="8",  name="calcui_button_8"}).sprite = "sprite_calcui_dark"
		row2.add({type="sprite-button", style="calcui_button_style_dark",  caption="9",  name="calcui_button_9"}).sprite = "sprite_calcui_dark"
		row2.add({type="sprite-button", style="calcui_button_style_light", caption="*",  name="calcui_button_MUL"}).sprite = "sprite_calcui_light"

		local row3 = col1.add({type="flow", name="calcui_col1_row3", direction="horizontal"})
		row3.add({type="sprite-button", style="calcui_button_style_dark",  caption="4",  name="calcui_button_4"}).sprite = "sprite_calcui_dark"
		row3.add({type="sprite-button", style="calcui_button_style_dark",  caption="5",  name="calcui_button_5"}).sprite = "sprite_calcui_dark"
		row3.add({type="sprite-button", style="calcui_button_style_dark",  caption="6",  name="calcui_button_6"}).sprite = "sprite_calcui_dark"
		row3.add({type="sprite-button", style="calcui_button_style_light", caption="-",  name="calcui_button_SUB"}).sprite = "sprite_calcui_light"

		local row4 = col1.add({type="flow", name="calcui_col1_row4", direction="horizontal"})
		row4.add({type="sprite-button", style="calcui_button_style_dark",  caption="1",  name="calcui_button_1"}).sprite = "sprite_calcui_dark"
		row4.add({type="sprite-button", style="calcui_button_style_dark",  caption="2",  name="calcui_button_2"}).sprite = "sprite_calcui_dark"
		row4.add({type="sprite-button", style="calcui_button_style_dark",  caption="3",  name="calcui_button_3"}).sprite = "sprite_calcui_dark"
		row4.add({type="sprite-button", style="calcui_button_style_light", caption="+",  name="calcui_button_ADD"}).sprite = "sprite_calcui_light"

		local row5 = col1.add({type="flow", name="calcui_col1_row5", direction="horizontal"})
		row5.add({type="sprite-button", style="calcui_button_style_light", caption="%",  name="calcui_button_PERC"}).sprite = "sprite_calcui_light"
		row5.add({type="sprite-button", style="calcui_button_style_dark",  caption="0",  name="calcui_button_0"}).sprite = "sprite_calcui_dark"
		row5.add({type="sprite-button", style="calcui_button_style_dark",  caption=".",  name="calcui_button_DOT"}).sprite = "sprite_calcui_dark"
		row5.add({type="sprite-button", style="calcui_button_style_red",   caption="=",  name="calcui_button_EQU"}).sprite = "sprite_calcui_red"

		local col2 = table.add({
			type = "flow",
			name = "calcui_table_col2",
			direction = "vertical"
		})

		local result = col2.add({
			type = "flow",
			name = "calcui_result",
			direction = "horizontal"
		})

		result.add({
			type = "label",
			caption = "=",
			name = "calcui_display_sign"
		}).style.font = "default-large"

		result.add({
			type = "label",
			caption = "",
			name = "calcui_copy_display_result"
		}).style.font = "default-large"

		col2.add({
			type = "sprite",
			name = "calcui_rant"
		})

		col2.add({
			type = "line",
			name = "calcui_line",
			direction = "horizontal"
		})

		local scroll = col2.add({
			type = "scroll-pane",
			name = "calcui_scroll_pane"
		})
		scroll.style.height = 252

		scroll.add({
			type = "table",
			caption = "",
			name = "calcui_result_table",
			column_count = "3"
		}).style.column_alignments[1] = "right"


		-- use last saved location or center the gui
		if not global.gui_position then
			global.gui_position = {}
		end
		if global.gui_position[player.index] then
			-- fix weird saved positions (out of reach)
			fix_oob_ui(player)

			calcui.location = global.gui_position[player.index]
		else
			calcui.force_auto_center()
		end

		-- focus on display
		display.focus()
	end
end

-- ----------------------------------------------------------------
local function hide_calculator(player)
	destroy_calculator(player)
end

-- ----------------------------------------------------------------
function focus_on_input(player)
	local root = get_gui_root(player)
	root.calcui.calcui_table.calcui_table_col1.calcui_display.focus()
end

-- ----------------------------------------------------------------
function toggle_calculator(player, extended_mode)
	extended_mode = extended_mode or false

	local root = get_gui_root(player)
	if root and root.calcui then
		-- root.calcui.calcui_table.calcui_table_col1.calcui_display.in_focus()? FIXME not possible with current api
		if extended_mode and not settings.get_player_settings(player)["calcui-shortcut-close"].value then
			focus_on_input(player)
		else
			hide_calculator(player)
		end
	else
		show_calculator(player)
	end
end

-- ----------------------------------------------------------------
local function clear_equation(player)
	local root = get_gui_root(player)
	root.calcui.calcui_table.calcui_table_col1.calcui_display.text = ""
end

-- ----------------------------------------------------------------
local function process_ce_key(player, button)
	local root = get_gui_root(player)
	clear_equation(player)
	local result = root.calcui.calcui_table.calcui_table_col2.calcui_result.calcui_copy_display_result
	result.caption = ""
	result.tooltip = ""
end

-- ----------------------------------------------------------------
local function process_c_key(player, button)
	local root = get_gui_root(player)
	process_ce_key(player, button)
	root.calcui.calcui_table.calcui_table_col2.calcui_scroll_pane.calcui_result_table.clear()
	global.recent_results[player.index] = {}
end

-- ----------------------------------------------------------------
local function process_backspace_key(player, button)
	local root = get_gui_root(player)
	local display = root.calcui.calcui_table.calcui_table_col1.calcui_display
	display.text = string.sub(display.text, 1, -2)
end

-- ----------------------------------------------------------------
local function draw_recent_table(player)
	local root = get_gui_root(player)

	local recent = root.calcui.calcui_table.calcui_table_col2.calcui_scroll_pane

	-- drop old table
	recent.calcui_result_table.clear()

	for i, result in ipairs(global.recent_results[player.index]) do
		recent.calcui_result_table.add({
			type = "label",
			name = "calcui_copy_equation_" .. i,
			caption = result["equation"],
			tooltip = {"calculator-ui.recent_tooltip"}
		})
		recent.calcui_result_table.add({
			type = "label",
			name = "calcui_sign_" .. i,
			caption = "="
		})
		recent.calcui_result_table.add({
			type = "label",
			name = "calcui_copy_result_" .. i,
			caption = result["result"]
		})
	end
	recent.scroll_to_top()
end

-- ----------------------------------------------------------------
local math_lib = {
	["abs"]   = "math.abs",
	["acos"]  = "math.acos",
	["asin"]  = "math.asin",
	["atan"]  = "math.atan",
	["atan2"] = "math.atan2",
	["ceil"]  = "math.ceil",
	["floor"] = "math.floor",
	["cos"]   = "math.cos",
	["cosh"]  = "math.cosh",
	["sin"]   = "math.sin",
	["sinh"]  = "math.sinh",
	["tan"]   = "math.tan",
	["tanh"]  = "math.tanh",
	["deg"]   = "math.deg",
	["rad"]   = "math.rad",
	["exp"]   = "math.exp",
	["log"]   = "math.log",
	["log10"] = "math.log10",
	["min"]   = "math.min",
	["max"]   = "math.max",
	["modf"]  = "math.modf",
	["fmod"]  = "math.fmod",
	["frexp"] = "math.frexp",
	["ldexp"] = "math.ldexp",
	["sqrt"]  = "math.sqrt",
	["huge"]  = "math.huge",
	["pi"]    = "math.pi",
	["pow"]   = "math.pow"
}
local function fix_equation(equation, root)
	local result = equation
	local prev_result = root.calcui.calcui_table.calcui_table_col2.calcui_result.calcui_copy_display_result.tooltip


	-- 1. visible part
	-- if equation does not start with a number or char, use the previous result (if available) and put it in front
	if not (string.match(result:sub(1, 1), "[^%w%(%)]") == nil) and prev_result then
		result = prev_result .. result
	end

	-- remove "math."
	result = result:gsub("math.", "")
	local new_equation = result


	-- 2. invisible part
	-- fix math library shortcuts
	for key, val in pairs(math_lib) do
		result = result:gsub(key, val)
	end

	-- fix percentage
	-- complex equations like "20+10%" = 22, before it was 20.1 -- big thanks to GWulf
	result = result:gsub("(%d+)(.)(%d+)%%", function (base, sign, perc)
		if sign == "+" then
			return base .. "*1." .. perc
		elseif sign == "-" then
			return base .. "*(1-0." ..perc .. ")"
		elseif sign == "*" then
			return "(" .. base .. "/100)*" .. perc
		elseif sign == "/" then
			return "(" .. base .. "*100)/" .. perc
		end
	end)
	-- still the simple equation needs some work: 1% = 0.01
	result = result:gsub("(%%)", "/100")

	-- fix danish keyboard
	result = result:gsub(",", ".")
	result = result:gsub(";", ",")


	return result, new_equation
end

-- ----------------------------------------------------------------
function process_equal_key(player, button)
	local root = get_gui_root(player)
	local original_equation = root.calcui.calcui_table.calcui_table_col1.calcui_display.text;

	equation, original_equation = fix_equation(original_equation, root)

	-- just testing
	--root.calcui.calcui_table.calcui_table_col1.calcui_display.text = equation

	if not (equation == nil or equation == "") then
		local status, retval = pcall(function()
			return load("return " .. equation)()
		end)
		root.calcui.calcui_table.calcui_table_col2.calcui_result.calcui_copy_display_result.tooltip = retval
		if not (retval == math.huge or retval ~= retval) then
			status, retval_show = pcall(function()
				local result = string.format("%0." .. settings.get_player_settings(player)["calcui-decimal-places"].value .. "f", retval)
				if result:len() > tostring(retval):len() then
					result = retval
				end
				return result
			end)
		else
			status = false
		end
		if retval_show == nil or retval_show == "" then
			status = false
		end
		if not status then
			retval_show = "NaN"
			show_rant(player, true)
		else
			if retval <= 0 then
				show_think(player, true)
			else
				show_rant(player, false)
			end
		end
		root.calcui.calcui_table.calcui_table_col2.calcui_result.calcui_copy_display_result.caption = retval_show

		-- only write in recent table if actually a result
		if status then
			-- check first equation and only insert if not the same
			if #global.recent_results[player.index] == 0 or global.recent_results[player.index][1]["equation"] ~= original_equation then
				table.insert(global.recent_results[player.index], 1, {
					equation = original_equation,
					result = retval_show
				})
			end
			draw_recent_table(player)
		end
	end

	if settings.get_player_settings(player)["calcui-clear-on-calc"].value then
		clear_equation(player)
	end
end

-- ----------------------------------------------------------------
local function display_addchar(player, char)
	local root = get_gui_root(player)
	local display = root.calcui.calcui_table.calcui_table_col1.calcui_display
	display.text = display.text .. char
	show_rant(player, false)
end

-- ----------------------------------------------------------------
local button_dispatch = {
	["CE"]  = process_ce_key,
	["C"]   = process_c_key,
	["BS"]  = process_backspace_key,
	--
	["EQU"] = process_equal_key
}
local button_addchar = {
	["DIV"]  = "/",
	--
	["7"]    = "7",
	["8"]    = "8",
	["9"]    = "9",
	["MUL"]  = "*",
	--
	["4"]    = "4",
	["5"]    = "5",
	["6"]    = "6",
	["SUB"]  = "-",
	--
	["1"]    = "1",
	["2"]    = "2",
	["3"]    = "3",
	["ADD"]  = "+",
	--
	["PERC"] = "%",
	["0"]    = "0",
	["DOT"]  = "."
}

function handle_calcui_click(event, player)
	debug_print("handle_calcui_click()")
	local event_name = event.element.name
	local button_prefix = "calcui_button_"
	local button_prefix_len = string.len(button_prefix)

	local copy_prefix = "calcui_copy_"
	local copy_prefix_len = string.len(copy_prefix);

	-- calculator buttons
	if string.sub(event_name, 1, button_prefix_len) == button_prefix then
		show_rant(player, false)

		button = string.sub(event_name, button_prefix_len + 1 )
		debug_print("handle_calcui_click button " .. button)
		local dispatch_func = button_dispatch[button]
		if dispatch_func then
			dispatch_func(player, button)
		end

		local addchar = button_addchar[button]
		if addchar then
			display_addchar(player, addchar)
		end
	-- close button
	elseif event_name == "calcui_close" then
		hide_calculator(player)
	-- copy results
	elseif string.sub(event_name, 1, copy_prefix_len) == copy_prefix then
		if event.button == defines.mouse_button_type.left and
		   event.shift == true then
			-- copy equation or result to display
			local root = get_gui_root(player)
			if event_name == "calcui_copy_display_result" then
				root.calcui.calcui_table.calcui_table_col1.calcui_display.text = root.calcui.calcui_table.calcui_table_col2.calcui_result.calcui_copy_display_result.caption
			else
				root.calcui.calcui_table.calcui_table_col1.calcui_display.text = root.calcui.calcui_table.calcui_table_col2.calcui_scroll_pane.calcui_result_table[event_name].caption
			end
		end
		focus_on_input(player)
	-- if else focus on focus on display
	else
		focus_on_input(player)
	end
end

-- ----------------------------------------------------------------
function calcui_on_gui_text_changed(event)
	if event.element.name == "calcui_display" then
		local player = game.players[event.player_index]
		local root = get_gui_root(player)
		if string.find(root.calcui.calcui_table.calcui_table_col1.calcui_display.text, "=") then
			root.calcui.calcui_table.calcui_table_col1.calcui_display.text = root.calcui.calcui_table.calcui_table_col1.calcui_display.text:gsub("=", "")
			process_equal_key(player)
		end
	end
end

-- ----------------------------------------------------------------
function calcui_on_gui_location_changed(event)
	if event.element.name == "calcui" then
		if not global.gui_position then
			global.gui_position = {}
		end
		global.gui_position[event.player_index] = event.element.location
	end
end