local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true

-- platform diff config
local function is_windows()
	return wezterm.target_triple:find("windows") ~= nil
end

local function is_macos()
	return string.find(wezterm.target_triple, "apple%-darwin") ~= nil
end

local mod = is_macos() and "CMD" or "CTRL"

if is_windows() then
	config.default_domain = "WSL:Ubuntu"
	config.default_cwd = "~"
end

-- theme (cyberpunk)
config.window_background_opacity = 0.88
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}
config.window_background_gradient = {
	orientation = "Vertical",
	colors = { "#050510", "#080818" },
}

-- pane border: neon cyan
config.inactive_pane_hsb = {
	saturation = 0.6,
	brightness = 0.4,
}

config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false
config.colors = {
	-- neon cyan pane borders
	split = "#00e5ff",

	-- cursor
	cursor_bg = "#00e5ff",
	cursor_border = "#00e5ff",
	cursor_fg = "#050510",

	-- selection
	selection_bg = "#004d5e",
	selection_fg = "#e0f7ff",

	tab_bar = {
		inactive_tab_edge = "none",
		background = "none",
		active_tab = {
			bg_color = "#00b4cc",
			fg_color = "#050510",
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = "#0d1a26",
			fg_color = "#4a7a8a",
		},
		inactive_tab_hover = {
			bg_color = "#0d2a36",
			fg_color = "#00e5ff",
		},
	},
}

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#0d1a26"
	local foreground = "#4a7a8a"
	local edge_background = "none"

	if tab.is_active then
		background = "#00b4cc"
		foreground = "#050510"
	end
	local edge_foreground = background
	-- 作業ディレクトリのベース名を取得、取れなければプロセスタイトルにフォールバック
	local cwd = ""
	local cwd_uri = tab.active_pane.current_working_dir
	if cwd_uri then
		local path = cwd_uri.file_path
		cwd = path:match("([^/]+)/*$") or path
	else
		cwd = tab.active_pane.title
	end
	local title = "   " .. wezterm.truncate_right(cwd, max_width - 1) .. "   "

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

-- typography
config.font_size = 13.0
config.font = wezterm.font_with_fallback({ "JetBrains Mono", "Noto Color Emoji" })

-- input
config.use_ime = true

-- keybinds
-- config.disable_default_key_bindings = true
-- local keybind = require 'keybinds'
config.keys = {
	-- Escape を2回送信: 1回目で IME の変換キャンセル、2回目が Neovim に届く
	{
		key = "Escape",
		mods = "",
		action = wezterm.action.Multiple({
			wezterm.action.SendKey({ key = "Escape" }),
			wezterm.action.SendKey({ key = "Escape" }),
		}),
	},
	{ key = "[", mods = "CTRL", action = wezterm.action.PaneSelect },
	{
		key = "V",
		mods = is_macos() and "CMD" or "CTRL",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "D",
		mods = is_macos() and "CMD" or "CTRL",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{ key = "C", mods = "SHIFT|CMD", action = wezterm.action.ActivateCopyMode },
	{ key = "H", mods = "CMD", action = wezterm.action.AdjustPaneSize({ "Left", 4 }) },
	{ key = "L", mods = "CMD", action = wezterm.action.AdjustPaneSize({ "Right", 4 }) },
	{ key = "J", mods = "CMD", action = wezterm.action.AdjustPaneSize({ "Down", 2 }) },
	{ key = "K", mods = "CMD", action = wezterm.action.AdjustPaneSize({ "Up", 2 }) },
}
-- config.key_tables = keybind.key_tables

-- on start
local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():toggle_fullscreen()
end)

return config
