-- calc-ui-styles.lua

local default_gui = data.raw["gui-style"].default

default_gui.calcui_icon_button =
{
  type = "button_style",
  parent = "button",
  default_font_color = {},
  size = 38,
  top_padding = 1,
  right_padding = 0,
  bottom_padding = 1,
  left_padding = 0,
  left_click_sound = {{ filename = "__core__/sound/gui-square-button.ogg", volume = 1 }},
  default_graphical_set =
  {
	filename = "__core__/graphics/gui.png",
	corner_size = 3,
	position = {8, 0},
	scale = 1
  }
}

default_gui.calcui_button_style = {
	type = "button_style",
	parent = "calcui_icon_button",
	top_padding = 0,
	right_padding = 0,
	bottom_padding = 0,
	left_padding = 0,
	height = 50,
	width = 50,
	scalable = false
}
default_gui.calcui_button_style_red = {
	type = "button_style",
	parent = "calcui_button_style",
	sprite = "sprite_calcui_red"
}
default_gui.calcui_button_style_light = {
	type = "button_style",
	parent = "calcui_button_style",
	sprite = "sprite_calcui_light"
}
default_gui.calcui_button_style_dark = {
	type = "button_style",
	parent = "calcui_button_style",
	sprite = "sprite_calcui_dark"
}

-- sprites
data:extend({
	{
		type = "sprite",
		name = "sprite_calcui_rant",
		filename = "__calculator-ui__/graphics/nilausRant.png",
		width = 56,
		height = 56
	},
	{
		type = "sprite",
		name = "sprite_calcui_think",
		filename = "__calculator-ui__/graphics/nilausThink.png",
		width = 56,
		height = 56
	},
	{
		type = "sprite",
		name = "sprite_calcui_calculator",
		filename = "__calculator-ui__/graphics/calculator.png",
		width = 64,
		height = 64
	},
	{
		type = "sprite",
		name = "sprite_calcui_backspace",
		filename = "__calculator-ui__/graphics/backspace.png",
		width = 50,
		height = 50
	},
	{
		type = "sprite",
		name = "sprite_calcui_red",
		filename = "__calculator-ui__/graphics/red.png",
		width = 50,
		height = 50
	},
	{
		type = "sprite",
		name = "sprite_calcui_light",
		filename = "__calculator-ui__/graphics/light.png",
		width = 50,
		height = 50
	},
	{
		type = "sprite",
		name = "sprite_calcui_dark",
		filename = "__calculator-ui__/graphics/dark.png",
		width = 50,
		height = 50
	}
})

-- audio
data:extend({
	{
		type = "sound",
		name = "calcui_home_improvement",
		filename = "__calculator-ui__/sounds/homeImprovement.ogg",
		category = "alert",
		volume = 1.0,
	},
	{
		type = "sound",
		name = "calcui_nilaus_fuck1",
		filename = "__calculator-ui__/sounds/nilausFuck1.ogg",
		category = "alert",
		volume = 1.0,
	},
	{
		type = "sound",
		name = "calcui_nilaus_fuck2",
		filename = "__calculator-ui__/sounds/nilausFuck2.ogg",
		category = "alert",
		volume = 1.0,
	},
	{
		type = "sound",
		name = "calcui_nilaus_fuck3",
		filename = "__calculator-ui__/sounds/nilausFuck3.ogg",
		category = "alert",
		volume = 1.0,
	},
	{
		type = "sound",
		name = "calcui_nilaus_really",
		filename = "__calculator-ui__/sounds/nilausReally.ogg",
		category = "alert",
		volume = 1.0,
	},
	{
		type = "sound",
		name = "calcui_nilaus_ugghhhh",
		filename = "__calculator-ui__/sounds/nilausUgghhhh.ogg",
		category = "alert",
		volume = 1.0,
	},
})