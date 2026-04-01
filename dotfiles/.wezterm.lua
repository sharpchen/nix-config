local wezterm = require('wezterm') --[[@as Wezterm]]
local mux = wezterm.mux
local action = wezterm.action
local config = wezterm.config_builder()

local env = {
  is_windows = package.config:sub(1, 1) == '\\',
  is_unix = package.config:sub(1, 1) == '/',
}

---@generic T
---@param arr T[]
---@return T
local function random(arr)
  math.randomseed(os.time())
  return arr[math.random(#arr)]
end

local font = random {
  'IBM Plex Mono',
  -- 'SF Mono',
  -- 'Cascadia Mono',
  -- 'Roboto Mono',
  -- 'JetBrains Mono NL',
}

local function regular()
  config.font_size = 12
  config.font = wezterm.font_with_fallback {
    font,
    'Nerd Font Symbols',
    'Noto Color Emoji',
    'Symbols Nerd Font Mono',
  }
  config.font_rules = {
    {
      intensity = 'Bold',
      italic = false,
      font = wezterm.font(font, { weight = 'Bold' }),
    },
  }
  config.front_end = 'OpenGL'
  -- see: https://wezterm.org/config/lua/wezterm.gui/get_appearance.html
  config.color_scheme = wezterm.gui
      and wezterm.gui.get_appearance():find('Dark')
      and random { 'kanagawabones', 'rose-pine-moon' }
    or random { 'rose-pine-dawn' }

  local colorscheme = wezterm.color.get_builtin_schemes()[config.color_scheme] or {}
  local blue = colorscheme.ansi[5]
  local white = colorscheme.ansi[8]
  local black = colorscheme.ansi[1]
  config.colors = {
    selection_bg = white,
    selection_fg = black,
    tab_bar = {
      background = blue,
      active_tab = {
        bg_color = blue,
        fg_color = wezterm.gui and wezterm.gui.get_appearance():find('Dark') and white
          or colorscheme.background,
        intensity = 'Bold',
      },
      inactive_tab = {
        bg_color = blue,
        fg_color = colorscheme.background,
        intensity = 'Half',
      },
      inactive_tab_hover = {
        bg_color = colorscheme.background,
        fg_color = white,
        intensity = 'Half',
      },
      new_tab = {
        bg_color = blue,
        fg_color = white,
        intensity = 'Half',
      },
      new_tab_hover = {
        bg_color = blue,
        fg_color = white,
        intensity = 'Bold',
      },
    },
  }
  config.default_prog = { 'pwsh', '--nologo' }
  config.animation_fps = 60
  config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  }
  config.window_content_alignment = {
    horizontal = 'Center',
    vertical = 'Center',
  }
  config.window_decorations = 'RESIZE'
  config.hide_tab_bar_if_only_one_tab = true
  config.tab_bar_at_bottom = true
  config.use_fancy_tab_bar = false
  config.tab_and_split_indices_are_zero_based = true

  config.cursor_blink_rate = 500
  config.cursor_blink_ease_in = 'Constant'
  config.cursor_blink_ease_out = 'Constant'
end

local function keymaps()
  config.leader = { key = 's', mods = 'CTRL', timeout_miliseconds = 2000 }
  config.keys = {
    {
      mods = 'LEADER',
      key = 'a',
      action = action.SpawnTab('CurrentPaneDomain'),
    },
    {
      mods = 'LEADER',
      key = 'c',
      action = action.CloseCurrentPane { confirm = true },
    },
    {
      mods = 'LEADER',
      key = 'b',
      action = action.ActivateTabRelative(-1),
    },
    {
      mods = 'LEADER',
      key = 'n',
      action = action.ActivateTabRelative(1),
    },
    {
      mods = 'LEADER',
      key = '\\',
      action = action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
      mods = 'LEADER',
      key = '-',
      action = action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
      mods = 'LEADER',
      key = 'h',
      action = action.ActivatePaneDirection('Left'),
    },
    {
      mods = 'LEADER',
      key = 'j',
      action = action.ActivatePaneDirection('Down'),
    },
    {
      mods = 'LEADER',
      key = 'k',
      action = action.ActivatePaneDirection('Up'),
    },
    {
      mods = 'LEADER',
      key = 'l',
      action = action.ActivatePaneDirection('Right'),
    },
    {
      mods = 'LEADER',
      key = 'LeftArrow',
      action = action.AdjustPaneSize { 'Left', 5 },
    },
    {
      mods = 'LEADER',
      key = 'RightArrow',
      action = action.AdjustPaneSize { 'Right', 5 },
    },
    {
      mods = 'LEADER',
      key = 'DownArrow',
      action = action.AdjustPaneSize { 'Down', 5 },
    },
    {
      mods = 'LEADER',
      key = 'UpArrow',
      action = action.AdjustPaneSize { 'Up', 5 },
    },
  }
  config.mouse_bindings = {
    {
      event = { Down = { streak = 1, button = 'Right' } },
      mods = 'NONE',
      action = wezterm.action_callback(function(window, pane)
        local has_selection = window:get_selection_text_for_pane(pane) ~= ''
        if has_selection then
          window:perform_action(action.CopyTo('ClipboardAndPrimarySelection'), pane)
          window:perform_action(action.ClearSelection, pane)
        else
          window:perform_action(action { PasteFrom = 'Clipboard' }, pane)
        end
      end),
    },
  }
end

local function events()
  wezterm.on('gui-startup', function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    local gui_window = window:gui_window()
    gui_window:maximize()
    gui_window:perform_action(action.ToggleFullScreen, pane)
  end)
end

regular()
keymaps()
events()

return config
