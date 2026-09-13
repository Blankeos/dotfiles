local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- config.font = wezterm.font("BlexMono Nerd Font")
config.font = wezterm.font("JetBrainsMono Nerd Font Propo")
config.font_size = 13

config.window_decorations = "RESIZE"

config.window_background_opacity = 0.90
config.macos_window_background_blur = 13
config.colors = {
    background = "rgba(18, 18, 18, 1)",
    cursor_bg = "rgba(186, 230, 253, 1)",
    selection_bg = "rgba(96, 165, 250, 0.4)",
}
config.max_fps = 120

-- Disabled 2026-09-06: true gives fast ESC in inner TUIs (helix,
-- lazygit, crabcode) but breaks herdr prefix+w picker Enter/Esc.
-- Herdr 0.8.2 troubleshooting notes kitty double-fire issues (#1116).
-- Keep false until herdr picker handles CSI-u.
config.enable_kitty_keyboard = false
 
config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 2000 }
config.keys = {
    -- Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
    {
        key = "LeftArrow",
        mods = "OPT",
        action = wezterm.action.SendKey({
            key = "b",
            mods = "ALT",
        }),
    },
    {
        key = "RightArrow",
        mods = "OPT",
        action = wezterm.action.SendKey({ key = "f", mods = "ALT" }),
    },
    -- CMD-Left/Right: beginning/end of line; CMD-Backspace: delete to beginning.
    -- Implemented as CTRL-A / CTRL-E / CTRL-U: readline (Emacs) line-editing
    -- keys understood by bash, zsh, and most TUIs. This translates macOS GUI
    -- muscle-memory (Cmd jumps to line edge) into sequences shells already
    -- understand, so it works over SSH and inside tmux/mprocs too.
    {
        key = "LeftArrow",
        mods = "CMD",
        action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
    },
    {
        key = "RightArrow",
        mods = "CMD",
        action = wezterm.action.SendKey({ key = "e", mods = "CTRL" }),
    },
    {
        key = "Backspace",
        mods = "CMD",
        action = wezterm.action.SendKey({ key = "u", mods = "CTRL" }),
    },
    -- CMD-SHIFT-Left/Right: select to beginning/end of line.
    -- Not a terminal standard; Shift+Home/End is the closest widely-supported
    -- convention (xterm/Windows/Linux). Needed because CTRL-A/E above are
    -- single chars and can't carry SHIFT in legacy encoding, so CMD|SHIFT
    -- would otherwise arrive stripped as plain Shift+Arrow (one-char select).
    {
        key = "LeftArrow",
        mods = "CMD|SHIFT",
        action = wezterm.action.SendKey({ key = "Home", mods = "SHIFT" }),
    },
    {
        key = "RightArrow",
        mods = "CMD|SHIFT",
        action = wezterm.action.SendKey({ key = "End", mods = "SHIFT" }),
    },

    -- TMux Style
    {
        mods = "LEADER",
        key = "c",
        action = wezterm.action.SpawnTab("CurrentPaneDomain"),
    },
    {
        mods = "LEADER",
        key = "x",
        action = wezterm.action.CloseCurrentPane({ confirm = true }),
    },
    {
        mods = "LEADER",
        key = "b",
        action = wezterm.action.ActivateTabRelative(-1),
    },
    {
        mods = "LEADER",
        key = "n",
        action = wezterm.action.ActivateTabRelative(1),
    },
    {
        mods = "LEADER",
        key = "v",
        action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
        mods = "LEADER",
        key = "d",
        action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
    },

    -- Resizing
    {
        mods = "LEADER",
        key = "RightArrow",
        action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
    },
    {
        mods = "LEADER",
        key = "LeftArrow",
        action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
    },
    {
        mods = "LEADER",
        key = "UpArrow",
        action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
    },
    {
        mods = "LEADER",
        key = "DownArrow",
        action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
    },

    -- Navigating
    {
        mods = "LEADER",
        key = "j",
        action = wezterm.action.ActivatePaneDirection("Down"),
    },
    {
        mods = "LEADER",
        key = "k",
        action = wezterm.action.ActivatePaneDirection("Up"),
    },
    {
        mods = "LEADER",
        key = "h",
        action = wezterm.action.ActivatePaneDirection("Left"),
    },
    {
        mods = "LEADER",
        key = "l",
        action = wezterm.action.ActivatePaneDirection("Right"),
    },
}

-- tab bar
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
-- config.enable_tab_bar = false
config.use_fancy_tab_bar = false

return config
