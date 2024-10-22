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

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    function tab_title(tab_info)
      local title = tab_info.tab_title
      if title and #title > 0 then
        return title
      end
      return tab_info.active_pane.title
    end
    local arrow = wezterm.nerdfonts.pl_right_hard_divider
    local edge_background = '#131a24'
    local background = '#1b1032'
    local foreground = '#808080'

    if tab.is_active then
      background = '#71839b'
      foreground = '#192330'
    elseif hover then
      background = '#29394f'
      foreground = '#cdcecf'
    end

    local edge_foreground = background
    local title = tab_title(tab)
    title = wezterm.truncate_right(title, max_width - 2)

    return {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = arrow },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = " " .. title .. " " },
      { Background = { Color = edge_foreground } },
      { Foreground = { Color = edge_background } },
      { Text = arrow },
    }
  end
)

-- tokyonight
-- config.colors = {
--   foreground = "#c0caf5",
--   background = "#1a1b26",
--   cursor_bg = "#c0caf5",
--   cursor_border = "#c0caf5",
--   cursor_fg = "#1a1b26",
--   selection_bg = "#283457",
--   selection_fg = "#c0caf5",
--   ansi = {
--     "#15161e",
--     "#f7768e",
--     "#9ece6a",
--     "#e0af68",
--     "#7aa2f7",
--     "#bb9af7",
--     "#7dcfff",
--     "#a9b1d6"
--   },
--   brights = {
--     "#414868",
--     "#f7768e",
--     "#9ece6a",
--     "#e0af68",
--     "#7aa2f7",
--     "#bb9af7",
--     "#7dcfff",
--     "#c0caf5"
--   },
--   tab_bar = {
--     inactive_tab_edge = "#16161e",
--     background = "#0b0022",
--     active_tab = {
--       fg_color = "#7aa2f7",
--       bg_color = "#1a1b26"
--     },
--     inactive_tab = {
--       bg_color = "#16161e",
--       fg_color = "#545c7e"
--     },
--     inactive_tab_hover = {
--       bg_color = "#16161e",
--       fg_color = "#7aa2f7"
--     },
--     new_tab_hover = {
--       fg_color = "#16161e",
--       bg_color = "#7aa2f7"
--     },
--     new_tab = {
--       fg_color = "#7aa2f7",
--       bg_color = "#191b28"
--     }
--   }
-- }

-- nightfox
config.colors = {
  foreground = "#cdcecf",
  background = "#192330",
  cursor_bg = "#cdcecf",
  cursor_border = "#cdcecf",
  cursor_fg = "#192330",
  compose_cursor = '#f4a261',
  selection_bg = "#2b3b51",
  selection_fg = "#cdcecf",
  scrollbar_thumb = "#71839b",
  split = "#131a24",
  visual_bell = "#cdcecf",
  ansi = { "#393b44", "#c94f6d", "#81b29a", "#dbc074", "#719cd6", "#9d79d6", "#63cdcf", "#dfdfe0" },
  brights = { "#575860", "#d16983", "#8ebaa4", "#e0c989", "#86abdc", "#baa1e2", "#7ad5d6", "#e4e4e5" },
  tab_bar = {
    background = "#131a24",
    inactive_tab_edge = "#131a24",
    inactive_tab_edge_hover = "#212e3f",

    active_tab = {
      bg_color = "#71839b",
      fg_color = "#192330",
      intensity = "Normal",
      italic = false,
      strikethrough = false,
      underline = "None",
    },
    inactive_tab = {
      bg_color = "#212e3f",
      fg_color = "#aeafb0",
      intensity = "Normal",
      italic = false,
      strikethrough = false,
      underline = "None",
    },
    inactive_tab_hover = {
      bg_color = "#29394f",
      fg_color = "#cdcecf",
      intensity = "Normal",
      italic = false,
      strikethrough = false,
      underline = "None",
    },
    new_tab_hover = {
      bg_color = "#29394f",
      fg_color = "#cdcecf",
      intensity = "Normal",
      italic = false,
      strikethrough = false,
      underline = "None",
    },
    new_tab = {
      bg_color = "#192330",
      fg_color = "#aeafb0",
      intensity = "Normal",
      italic = false,
      strikethrough = false,
      underline = "None",
    }
  }
}

config.font_size = 14
config.use_fancy_tab_bar = false
config.tab_max_width = 18
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
