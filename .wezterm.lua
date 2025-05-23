-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font("BlexMono Nerd Font")
config.font_size = 13

config.window_decorations = "RESIZE"

config.window_background_opacity = 0.8
config.macos_window_background_blur = 10
config.colors = {
	background = "rgba(18, 18, 18, 1)",
	cursor_bg = "rgba(186, 230, 253, 1)",
	selection_bg = "rgba(96, 165, 250, 0.4)",
}
config.max_fps = 120;

return config
