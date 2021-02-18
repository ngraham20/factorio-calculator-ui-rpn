-- calc-ui-prototypes.lua

data:extend({
	{
		type = "shortcut",
		name = "calcui_4func",
		order = "b[blueprints]-h[calculator-ui]",
		action = "lua",
		toggleable = true,
		icon =
		{
			filename = "__calculator-ui__/graphics/calculator.png",
			priority = "extra-high-no-scale",
			size = 64,
			scale = 1,
			flags = {"icon"}
		}
	}
})