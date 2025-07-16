---@module 'lazy'
---@type LazySpec
return {
  'ibhagwan/fzf-lua',
  enabled = false,
  config = function()
    do
      if vim.fn.executable('fd') == 0 then
        vim.notify('fd not installed', vim.log.levels.ERROR)
        return
      end
    end

    local fzf = require('fzf-lua')
    fzf.register_ui_select()
    if IsWindows then
      fzf.setup {
        winopts = {
          preview = { default = 'bat_native' },
        },
        fzf_opts = {
          ['--cycle'] = true,
          ['--ansi'] = false,
        },
        files = {
          git_icons = false,
          file_icons = false,
        },
      }
    else
      fzf.setup {
        fzf_opts = {
          ['--cycle'] = true,
        },
        previewers = {
          builtin = {
            extensions = {
              ['png'] = { 'viu', '-b' },
              ['jpg'] = { 'viu', '-b' },
            },
          },
        },
        actions = {
          files = {
            true,
            ['alt-e'] = function(_, opts)
              local f = vim.fs.joinpath(opts.cwd, opts.last_query)
              local e = vim.api.nvim_replace_termcodes('<Esc>:e ', true, true, true)
              vim.api.nvim_feedkeys(e .. f, 'L', false)
            end,
          },
        },
      }
    end

    vim.keymap.set('n', '<leader>fc', function()
      local config_path = IsWindows and vim.fn.stdpath('config')
        or vim.fn.expand('~/.config/home-manager/dotfiles/nvim-config/')
      fzf.files { cwd = config_path }
    end, { desc = 'find nvim config file' })

    vim.keymap.set('n', '<leader>fg', fzf.live_grep_resume, { desc = 'grep from files' })
    vim.keymap.set(
      'n',
      '<leader>ff',
      fzf.git_files,
      { desc = 'find in all tracked files' }
    )
    vim.keymap.set('n', '<leader>fh', fzf.help_tags, { desc = 'help tags' })
    vim.keymap.set('n', '<leader>fa', fzf.files, { desc = 'find files' })
    vim.keymap.set('n', '<leader>ca', fzf.lsp_code_actions, { desc = 'code actions' })
    vim.keymap.set(
      'n',
      '<leader>fe',
      fzf.diagnostics_document,
      { desc = 'document diagnostics' }
    )
    vim.keymap.set('n', '<leader>fo', fzf.oldfiles, { desc = 'search recent files' })

    vim.keymap.set(
      'n',
      '<leader>fd',
      function() fzf.files { cmd = 'fd -t=d -E .git/', cwd = vim.uv.cwd() } end,
      { desc = 'search folders' }
    )

    vim.keymap.set(
      'n',
      '<leader>fb',
      function()
        fzf.files {
          cmd = 'fd -d 1',
          cwd = vim.fs.dirname(vim.fn.bufname('%')):gsub('^oil://', ''),
        }
      end,
      { desc = 'find files in current folder' }
    )

    vim.keymap.set(
      'n',
      '<leader>fr',
      function() vim.cmd(('Oil %s'):format(vim.uv.cwd())) end,
      { desc = 'root folder' }
    )

    vim.keymap.set('n', [[<leader>fl]], function()
      local lazy_path = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy')
      fzf.fzf_exec('fd -d 1 -t=d -E .git/', {
        cwd = lazy_path,
        actions = {
          default = function(selected, _)
            vim.fn.chdir(vim.fs.joinpath(lazy_path, selected[1]))
          end,
        },
      })
    end, { desc = 'search plugin source file installed by lazy' })

    vim.api.nvim_create_autocmd('ModeChanged', {
      pattern = 't:n',
      callback = function(args)
        local is_file = vim.fn.filereadable(vim.api.nvim_buf_get_name(args.buf)) == 1
        local is_writable = vim.bo[args.buf].modifiable and not vim.bo[args.buf].readonly
        if is_file and is_writable then
          vim.defer_fn(
            function()
              vim.api.nvim_feedkeys(require('utils.text').termcode('i<Esc>'), 'tx', false)
            end,
            200
          )
        end
      end,
      desc = 'invoke ufo after entering buf using fzf-lua',
    })

    vim.keymap.set('n', [[<leader>fp]], function()
      local cwd = vim.fn.expand('~/projects/')
      require('fzf-lua').fzf_exec('fd -d 1 -t=d -E .git/', {
        cwd = cwd,
        actions = {
          default = function(selected, _) vim.fn.chdir(vim.fs.joinpath(cwd, selected[1])) end,
        },
      })
    end, { desc = 'find projects' })
  end,
}
