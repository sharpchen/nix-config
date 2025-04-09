require('lspconfig').ts_query_ls.setup {
  settings = {
    parser_install_directories = {
      -- If using nvim-treesitter with lazy.nvim
      vim.fs.joinpath(
        vim.fn.stdpath('data') --[[@as string]],
        '/lazy/nvim-treesitter/parser/'
      ),
    },
  },
}
