local wezterm = require 'wezterm'
local config = {}

local wsl_domains = wezterm.default_wsl_domains()
config.wsl_domains = wsl_domains

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.automatically_reload_config = true

config.check_for_updates = true
config.check_for_updates_interval_seconds = 86400

config.scrollback_lines = 3500

config.use_ime = true

config.default_prog = { 'pwsh.exe' }

config.launch_menu = {
	{
		label = 'Git Bash',
		args = { 'C:\\Program Files\\Git\\bin\\bash.exe', '-l' }
	},
	{
		label = 'cmd',
		args = { 'C:\\Windows\\System32\\cmd.exe' }
	}
}

-- color schema
config.color_scheme = 'nightfox'

wezterm.font("Moralerspace Neon NF", { weight = "Regular", stretch = "Normal", style = "Normal" })
-- C:\USERS\MERCU\APPDATA\LOCAL\MICROSOFT\WINDOWS\FONTS\MORALERSPACENEONNF-REGULAR.TTF, DirectWrite
wezterm.font_size = 10.0
wezterm.adjust_window_size_when_changing_font_size = false

local function is_claude(pane)
  local process = pane:get_foreground_process_info()
  if not process or not process.argv then
    return false
  end

  for _, arg in ipairs(process.argv) do
    if arg:find("claude") then
      return true
    end
  end
  return false
end

wezterm.GLOBAL.bell_tabs = wezterm.GLOBAL.bell_tabs or {}

wezterm.on("bell", function(window, pane)
  local tab = pane:tab()
  if tab then
    wezterm.GLOBAL.bell_tabs[tostring(tab:tab_id())] = true
  end

  if is_claude(pane) then
    window:toast_notification("Claude Code", "Claude is calling", nil, 4000)
  else
    window:toast_notification("WezTerm", "Bell event triggered", nil, 4000)
  end
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local tab_id_str = tostring(tab.tab_id)

  if tab.is_active and wezterm.GLOBAL.bell_tabs[tab_id_str] then
    wezterm.GLOBAL.bell_tabs[tab_id_str] = nil
  end

  local title = tab.tab_title
  if title == nil or #title == 0 then
    title = tab.active_pane.title
  end

  if wezterm.GLOBAL.bell_tabs[tab_id_str] then
    return "● " .. title
  end
  return " " .. title
end)

config.leader = { key = '\\', mods = 'CTRL', timeout_milliseconds = 2000 }

local act = wezterm.action

config.keys = {
	{
		key = 'l',
		mods = 'ALT',
		action = wezterm.action.ShowLauncher,
	},
	{
		key="Enter",
		mods="SHIFT",
		action=wezterm.action{
			SendString="\x1b\r"
		},
	},
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
	{
		key = 't',
		mods = 'LEADER|CTRL',
		action = act.SpawnTab 'CurrentPaneDomain',
	},
	{
		key = 'd',
		mods = 'LEADER|CTRL',
		action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
	},

	-- Enable copy mode
	{ key = 'v', mods = 'LEADER', action = wezterm.action.ActivateCopyMode },

	-- Move pane
	{ key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
	{ key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },
	{ key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
	{ key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },

	-- Switch tab
	{ key = 'h', mods = 'LEADER|CTRL', action = wezterm.action.ActivateTabRelative(-1) },
	{ key = 'l', mods = 'LEADER|CTRL', action = wezterm.action.ActivateTabRelative(1) },

	-- Ctrl+左矢印でカーソルを前の単語に移動
	{
		key = "LeftArrow",
		mods = "CTRL",
		action = act.SendKey {
			key = "b",
			mods = "ALT",
		},
	},
	-- Ctrl+右矢印でカーソルを次の単語に移動
	{
		key = "RightArrow",
		mods = "CTRL",
		action = act.SendKey {
			key = "f",
			mods = "ALT",
		},
	},
	-- Ctrl+Backspaceで前の単語を削除
	{
		key = "Backspace",
		mods = "CTRL",
		action = act.SendKey {
			key = "w",
			mods = "CTRL",
		},
	},
}

return config
