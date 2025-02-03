local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- colors
config.color_scheme = 'AdventureTime'
config.window_background_opacity = 0.5

-- font
config.font_size = 13.0

-- keybinds
-- config.disable_default_key_bindings = true
-- local keybind = require 'keybinds'
config.keys = {
    { key = 'D', mods = 'CMD', action = wezterm.action.SplitVertical{ domain =  'CurrentPaneDomain' } },
}
-- config.key_tables = keybind.key_tables

-- on start
local mux = wezterm.mux
wezterm.on('gui-startup', function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():toggle_fullscreen()
  end)


return config