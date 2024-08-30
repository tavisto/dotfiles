-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

local act = wezterm.action


-- This is where you actually apply your config choices
-- ~/Library/Fonts/HackNerdFontMono-Regular.ttf
config.font = wezterm.font("Hack Nerd Font Mono", {
  weight="Regular",
  stretch="Normal",
  style="Normal"
})
config.font_size=14

-- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'
config.color_scheme = 'GitHub Lite'

config.show_close_tab_button_in_tabs = false

config.keys = {
  -- This will create a new vsplit
  {
    key = 'd',
    mods = 'CMD',
    action = wezterm.action.SplitPane {
      direction = 'Left',
      size = { Percent = 50 },
    },
  },
  -- This will create a new split and run the `top` program inside it
  {
    key = 'd',
    mods = 'SHIFT|CMD',
    action = wezterm.action.SplitPane {
      direction = 'Down',
      size = { Percent = 50 },
    },
  },
  {
    key = 'LeftArrow',
    mods = 'CMD|SHIFT',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'RightArrow',
    mods = 'CMD|SHIFT',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'UpArrow',
    mods = 'CMD|SHIFT',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'DownArrow',
    mods = 'CMD|SHIFT',
    action = act.ActivatePaneDirection 'Down',
  },
}


wezterm.on('update-status', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if window:is_focused() then
    overrides.color_scheme = 'Github Dark'
  else
    overrides.color_scheme = 'nightfox'
  end
  window:set_config_overrides(overrides)
end)

-- and finally, return the configuration to wezterm
return config
