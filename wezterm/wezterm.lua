local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Transparency
config.window_background_opacity = 1.0
-- config.macos_window_background_blur = 10

config.color_scheme = 'Catppuccin Mocha'
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 14

config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"

config.keys = {
    {
        key = 'Enter',
        mods = 'CMD',
        action = wezterm.action.SendString '\x1b[13;9u',
    },
    {
        key = 'Enter',
        mods = 'CMD|SHIFT',
        action = wezterm.action.SendString '\x1b[13;10u',
    },
}


return config
