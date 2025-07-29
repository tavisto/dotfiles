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
  style="Normal",
})
config.font_size=14

-- config.font.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }


-- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'
config.color_scheme = 'GitHub Lite'

-- config.show_close_tab_button_in_tabs = false

config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_function = 'Linear',
  fade_in_duration_ms = 75,
  fade_out_function = 'Linear',
  fade_out_duration_ms = 75,
}
config.colors = {
  visual_bell = '#200F20',
}

config.keys = {
  -- This will create a new vsplit to the left of the current pane
  {
    key = 'd',
    mods = 'CMD',
    action = wezterm.action.SplitPane {
      direction = 'Left',
      size = { Percent = 50 },
    },
  },
  -- This will create a new split underneath the current pane
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
