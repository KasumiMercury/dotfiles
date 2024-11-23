local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.automatically_reload_config = true

config.check_for_updates = true
config.check_for_updates_interval_seconds = 86400

config.scrollback_lines = 3500

config.use_ime = true

config.window_background_opacity = 0.85

-- color schema
config.color_scheme = 'nightfox'

wezterm.font("Moralerspace Neon NF", { weight = "Regular", stretch = "Normal", style = "Normal" })
-- C:\USERS\MERCU\APPDATA\LOCAL\MICROSOFT\WINDOWS\FONTS\MORALERSPACENEONNF-REGULAR.TTF, DirectWrite

config.leader = { key = 'o', mods = 'CTRL', timeout_milliseconds = 2000 }

config.keys = {
	{
		key = '|',
		mods = 'LEADER|SHIFT',
		action = wezterm.action.SplitPane {
			direction = 'Right',
			size = { Percent = 50 },
		},
	},
	{
		key = '-',
		mods = 'LEADER',
		action = wezterm.action.SplitPane {
			direction = 'Down',
			size = { Percent = 50 },
		},
	},

	-- Enable copy mode
	{ key = 'v', mods = 'LEADER', action = wezterm.action.ActivateCopyMode },

	-- Move pane
	{ key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
	{ key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },
	{ key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
	{ key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },
}

return config
