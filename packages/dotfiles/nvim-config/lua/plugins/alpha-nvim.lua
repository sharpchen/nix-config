return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  enabled = true,
  dependencies = { 'folke/persistence.nvim', 'jvgrootveld/telescope-zoxide' },
  init = false,
  opts = function()
    local dashboard = require('alpha.themes.dashboard')
    local random_color = { 'Keyword', 'Number', 'Type', '@type.builtin', 'String', '@variable.parameter' }
    local color = random_color[math.random(1, #random_color)]
    dashboard.section.header.type = 'group'
    dashboard.section.header.val = {
      {
        type = 'text',
        val = '   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
        opts = { hl = color, shrink_margin = false, position = 'center' },
      },
      {
        type = 'text',
        val = '   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
        opts = { hl = color, shrink_margin = false, position = 'center' },
      },
      {
        type = 'text',
        val = '   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
        opts = { hl = color, shrink_margin = false, position = 'center' },
      },
      {
        type = 'text',
        val = '   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
        opts = { hl = color, shrink_margin = false, position = 'center' },
      },
      {
        type = 'text',
        val = '   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
        opts = { hl = color, shrink_margin = false, position = 'center' },
      },
      {
        type = 'text',
        val = '   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
        opts = { hl = color, shrink_margin = false, position = 'center' },
      },
      {
        type = 'padding',
        val = 1,
      },
      {
        type = 'text',
        val = 'Hello :)',
        opts = { hl = color, shrink_margin = false, position = 'center' },
      },
    }
    -- stylua: ignore
    dashboard.section.buttons.val = {
      dashboard.button("f", " " .. " Find file",       "<cmd> Telescope find_files <cr>"),
      dashboard.button("n", " " .. " New file",        "<cmd> ene <BAR> startinsert <cr>"),
      dashboard.button("r", " " .. " Recent files",    "<cmd> Telescope oldfiles <cr>"),
      dashboard.button("g", " " .. " Find text",       "<cmd> Telescope live_grep <cr>"),
      dashboard.button("Z", " " .. " Open Directories", "<cmd> lua require('telescope').extensions.zoxide.list() <cr>"),
      dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
    --dashboard.button("x", " " .. " Lazy Extras",     "<cmd> LazyExtras <cr>"),
      dashboard.button("l", "󰒲 " .. " Lazy",            "<cmd> Lazy <cr>"),
      dashboard.button("q", " " .. " Quit",            "<cmd> qa <cr>"),
    }
    vim.api.nvim_set_hl(0, 'AlphaHeader', { fg = '#311B92' }) -- Dark Indigo
    vim.api.nvim_set_hl(0, 'AlphaShortcut', { fg = '#8BC34A' }) -- Greenish
    vim.api.nvim_set_hl(0, 'AlphaFooter', { fg = '#edd691' })

    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = color
      button.opts.hl_shortcut = 'String'
    end
    dashboard.section.header.opts.hl = 'AlphaHeader'
    dashboard.section.buttons.opts.hl = color
    dashboard.section.footer.opts.hl = 'Parameter'
    dashboard.opts.layout[1].val = 3
    return dashboard
  end,
  config = function(_, dashboard)
    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == 'lazy' then
      vim.cmd.close()
      vim.api.nvim_create_autocmd('User', {
        once = true,
        pattern = 'AlphaReady',
        callback = function()
          require('lazy').show()
        end,
      })
    end

    require('alpha').setup(dashboard.opts)

    vim.api.nvim_create_autocmd('User', {
      once = true,
      pattern = 'LazyVimStarted',
      callback = function()
        local stats = require('lazy').stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = '⚡ Neovim loaded '
          .. stats.loaded
          .. '/'
          .. stats.count
          .. ' plugins in '
          .. ms
          .. 'ms'
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
