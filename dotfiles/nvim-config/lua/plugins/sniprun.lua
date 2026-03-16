---@module 'lazy'
---@type LazySpec
return {
  'michaelb/sniprun',
  branch = 'master',
  build = 'sh install.sh 1',
  enabled = not IsWindows, -- sniprun does not support Windows
  event = 'VeryLazy',
  config = function()
    require('sniprun').setup {
      display = {
        'VirtualText',
        'Classic',
      },
      selected_interpreters = { 'Lua_nvim', 'Generic' },
      interpreter_options = {
        Generic = {
          error_truncate = 'long', -- strongly recommended to figure out what's going on
          nix = { -- any key name is ok
            supported_filetypes = { 'nix' },
            extension = '.nix',
            interpreter = 'nix eval --raw -f',
          },
          ps1 = {
            supported_filetypes = { 'ps1' },
            extension = '.ps1',
            interpreter = 'pwsh -noprofile -nologo -noninteractive -f',
          },
          csharp = {
            supported_filetypes = { 'cs' },
            interpreter = 'dotnet run --verbosity quiet -p:AllowUnsafeBlocks=true',
            extension = '.cs',
            boilerplate_pre = [[
            using System;
            using System.Collections.Generic;
            using System.Linq;
            using System.Threading.Tasks;
            using System.IO;
            using System.Text;
            using System.Text.Json;
            using System.Globalization;
            ]],
          },
          fsharp = {
            supported_filetypes = { 'fsharp' },
            interpreter = 'dotnet fsi --nologo --exec --utf8output',
            extension = '.fsx',
            boilerplate_pre = [[
            open System;
            open System.Collections.Generic;
            open System.Linq;
            open System.Threading.Tasks;
            open System.IO;
            open System.Text;
            open System.Text.Json;
            using System.Globalization;
            ]],
          },
        },
      },
    }
    vim.keymap.set({ 'v', 'x' }, '<leader>e', ':SnipRun<CR>', { desc = 'sniprun' })
    vim.keymap.set(
      'n',
      '<leader>e',
      require('utils.static').mark.wrap(function() vim.cmd('SnipRun') end),
      { desc = 'sniprun' }
    )
    vim.api.nvim_create_autocmd({ 'TextChangedI', 'BufWrite' }, {
      command = 'SnipClose',
      desc = 'close SnipRun virtual text',
    })
  end,
}
