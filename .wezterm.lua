local wezterm = require("wezterm")

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
config.max_fps = 120

config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 2000 }
config.keys = {
    -- Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
    {
        key = 'LeftArrow',
        mods = 'OPT',
        action = wezterm.action.SendKey {
            key = 'b',
            mods = 'ALT',
        },
    },
    {
        key = 'RightArrow',
        mods = 'OPT',
        action = wezterm.action.SendKey { key = 'f', mods = 'ALT' },
    },

    -- TMux Style
    {
        mods = "LEADER",
        key = "c",
        action = wezterm.action.SpawnTab "CurrentPaneDomain"
    },
    {
        mods = "LEADER",
        key = "x",
        action = wezterm.action.CloseCurrentPane { confirm = true }
    },
    {
        mods = "LEADER",
        key = "b",
        action = wezterm.action.ActivateTabRelative(-1)
    },
    {
        mods = "LEADER",
        key = "n",
        action = wezterm.action.ActivateTabRelative(1)
    },
    {
        mods = "LEADER",
        key = "v",
        action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }
    },
    {
        mods = "LEADER",
        key = "d",
        action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" }
    },

    -- Resizing
    {
        mods = "LEADER",
        key = "RightArrow",
        action = wezterm.action.AdjustPaneSize { "Right", 5 }
    },
    {
        mods = "LEADER",
        key = "LeftArrow",
        action = wezterm.action.AdjustPaneSize { "Left", 5 }
    },
    {
        mods = "LEADER",
        key = "UpArrow",
        action = wezterm.action.AdjustPaneSize { "Up", 5 }
    },
    {
        mods = "LEADER",
        key = "DownArrow",
        action = wezterm.action.AdjustPaneSize { "Down", 5 }
    },

    -- Navigating
    {
        mods = "LEADER",
        key = "j",
        action = wezterm.action.ActivatePaneDirection "Down"
    },
    {
        mods = "LEADER",
        key = "k",
        action = wezterm.action.ActivatePaneDirection "Up"
    },
    {
        mods = "LEADER",
        key = "h",
        action = wezterm.action.ActivatePaneDirection "Left"
    },
    {
        mods = "LEADER",
        key = "l",
        action = wezterm.action.ActivatePaneDirection "Right"
    }
}

-- tab bar
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
-- config.enable_tab_bar = false
config.use_fancy_tab_bar = false

return config
