local wezterm = require('wezterm') --[[@as Wezterm]]
local mux = wezterm.mux
local act = wezterm.action
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
  'JetBrains Mono NL',
  'SF Mono',
  'Cascadia Mono',
  'IBM Plex Mono',
  'Roboto Mono',
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

  if config.color_scheme == 'rose-pine-moon' then
    config.colors = {
      selection_bg = '#d2d0e7',
      selection_fg = '#26233a',
    }
  elseif config.color_scheme == 'rose-pine-dawn' then
    config.colors = {
      selection_bg = '#575279',
      selection_fg = '#faf4ed',
    }
  end

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
      action = wezterm.action.SpawnTab('CurrentPaneDomain'),
    },
    {
      mods = 'LEADER',
      key = 'c',
      action = wezterm.action.CloseCurrentPane { confirm = true },
    },
    {
      mods = 'LEADER',
      key = 'b',
      action = wezterm.action.ActivateTabRelative(-1),
    },
    {
      mods = 'LEADER',
      key = 'n',
      action = wezterm.action.ActivateTabRelative(1),
    },
    {
      mods = 'LEADER',
      key = '\\',
      action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
      mods = 'LEADER',
      key = '-',
      action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
      mods = 'LEADER',
      key = 'h',
      action = wezterm.action.ActivatePaneDirection('Left'),
    },
    {
      mods = 'LEADER',
      key = 'j',
      action = wezterm.action.ActivatePaneDirection('Down'),
    },
    {
      mods = 'LEADER',
      key = 'k',
      action = wezterm.action.ActivatePaneDirection('Up'),
    },
    {
      mods = 'LEADER',
      key = 'l',
      action = wezterm.action.ActivatePaneDirection('Right'),
    },
    {
      mods = 'LEADER',
      key = 'LeftArrow',
      action = wezterm.action.AdjustPaneSize { 'Left', 5 },
    },
    {
      mods = 'LEADER',
      key = 'RightArrow',
      action = wezterm.action.AdjustPaneSize { 'Right', 5 },
    },
    {
      mods = 'LEADER',
      key = 'DownArrow',
      action = wezterm.action.AdjustPaneSize { 'Down', 5 },
    },
    {
      mods = 'LEADER',
      key = 'UpArrow',
      action = wezterm.action.AdjustPaneSize { 'Up', 5 },
    },
  }
  config.mouse_bindings = {
    {
      event = { Down = { streak = 1, button = 'Right' } },
      mods = 'NONE',
      action = wezterm.action_callback(function(window, pane)
        local has_selection = window:get_selection_text_for_pane(pane) ~= ''
        if has_selection then
          window:perform_action(act.CopyTo('ClipboardAndPrimarySelection'), pane)
          window:perform_action(act.ClearSelection, pane)
        else
          window:perform_action(act { PasteFrom = 'Clipboard' }, pane)
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
    gui_window:perform_action(wezterm.action.ToggleFullScreen, pane)
  end)

  wezterm.on('user-var-changed', function(window, pane, name, value)
    if name == 'NVIM_COLO' then
      pane:inject_output(string.format('\x1b]11;%s\a', value))
    elseif name == 'NVIM_LEAVE' then
      pane:inject_output('\x1b]111\a') -- OSC 111 resets background
    end
  end)

  wezterm.on('update-right-status', function(window, _)
    local curr_config = window:effective_config()
    local colorscheme = wezterm.color.get_builtin_schemes()[curr_config.color_scheme]
      or {}
    local blue = colorscheme.ansi[5]
    local white = colorscheme.ansi[8]
    window:set_config_overrides {
      colors = {
        tab_bar = {
          background = blue,
          active_tab = {
            bg_color = blue,
            fg_color = wezterm.gui
                and wezterm.gui.get_appearance():find('Dark')
                and white
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
      },
    }
  end)
end

regular()
keymaps()
events()

return config
