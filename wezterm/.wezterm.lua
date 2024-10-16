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

wezterm.font("Moralerspace Neon NF", {weight="Regular", stretch="Normal", style="Normal"})
-- C:\USERS\MERCU\APPDATA\LOCAL\MICROSOFT\WINDOWS\FONTS\MORALERSPACENEONNF-REGULAR.TTF, DirectWrite

return config

