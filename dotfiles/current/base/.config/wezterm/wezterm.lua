local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

config.colors = {
  foreground = "#c0caf5",
  background = "#1a1b26",
  cursor_bg = "#c0caf5",
  cursor_border = "#c0caf5",
  cursor_fg = "#1a1b26",
  selection_bg = "#283457",
  selection_fg = "#c0caf5",
  ansi = {
    "#15161e",
    "#f7768e",
    "#9ece6a",
    "#e0af68",
    "#7aa2f7",
    "#bb9af7",
    "#7dcfff",
    "#a9b1d6"
  },
  brights = {
    "#414868",
    "#f7768e",
    "#9ece6a",
    "#e0af68",
    "#7aa2f7",
    "#bb9af7",
    "#7dcfff",
    "#c0caf5"
  },
  tab_bar = {
    inactive_tab_edge = "#16161e",
    background = "#0b0022",
    active_tab = {
      fg_color = "#7aa2f7",
      bg_color = "#1a1b26"
    },
    inactive_tab = {
      bg_color = "#16161e",
      fg_color = "#545c7e"
    },
    inactive_tab_hover = {
      bg_color = "#16161e",
      fg_color = "#7aa2f7"
    },
    new_tab_hover = {
      fg_color = "#16161e",
      bg_color = "#7aa2f7"
    },
    new_tab = {
      fg_color = "#7aa2f7",
      bg_color = "#191b28"
    }
  }
}

config.font_size = 14
config.use_fancy_tab_bar = false
config.default_cursor_style = 'BlinkingBar'
config.keys = {
  {
    key = 'E',
    mods = 'CTRL|SHIFT',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
  {
    key = '<', -- CTRL+SHIFT+,
    mods = 'CTRL|SHIFT',
    action = act.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },
}

return config
