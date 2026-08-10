-- Pull in the wezterm API
local wezterm = require("wezterm")

local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.colors = {
	foreground = "#CBE0F0",
	background = "#011423",
	cursor_bg = "#47FF9C",
	cursor_border = "#47FF9C",
	cursor_fg = "#011423",
	selection_bg = "#706b4e",
	selection_fg = "#f3d9c4",
	ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
	brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

config.font = wezterm.font("DroidSansM Nerd Font Mono")
config.font_size = 14
config.enable_tab_bar = false

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.98
config.macos_window_background_blur = 8

-- Forward Option as Alt/Meta. Keep Kitty keyboard negotiation disabled until
-- Herdr includes the fix for shifted alternates without a Shift modifier.
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false
config.enable_kitty_keyboard = false

config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.5,
}

config.keys = {
  {
    key = 'h',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Left',
  },
  {
      key="Enter",
      mods="SHIFT",
       action=wezterm.action{SendKey={key="Enter", mods="SHIFT"}},
  },
  {
    key = 'j',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Down'
  },
  {
    key = 'j',
    mods = 'CTRL|ALT',
    action = act.SendString '\x1b[106;7u'
  },
  {
    key = 'j',
    mods = 'CTRL|ALT|SHIFT',
    action = act.SendString '\x1b[106;8u'
  },
  {
    key = 'k',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Up'
  },
  {
    key = 'k',
    mods = 'CTRL|ALT',
    action = act.SendString '\x1b[107;7u'
  },
  {
    key = 'k',
    mods = 'CTRL|ALT|SHIFT',
    action = act.SendString '\x1b[107;8u'
  },
  {
    key = 'l',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Right'
  },
  {
    key = '[',
    mods = 'ALT',
    action = act.SendString '\x1b[91;3u'
  },
  {
    key = ']',
    mods = 'ALT',
    action = act.SendString '\x1b[93;3u'
  },
  {
    key = '[',
    mods = 'ALT|SHIFT',
    action = act.ActivateTabRelative(-1)
  },
  {
    key = ']',
    mods = 'ALT|SHIFT',
    action = act.ActivateTabRelative(1)
  }
}

-- Herdr uses Prefix+Alt+1..9 to focus agents. Encode the Alt key explicitly
-- so these chords remain unambiguous without Kitty keyboard negotiation.
for index = 1, 9 do
	table.insert(config.keys, {
		key = tostring(index),
		mods = 'ALT',
		action = act.SendString(string.format('\x1b[%d;3u', 48 + index)),
	})
end

-- and finally, return the configuration to wezterm
return config
