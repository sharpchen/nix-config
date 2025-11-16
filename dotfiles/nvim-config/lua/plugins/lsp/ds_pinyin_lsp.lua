if HasNix then
  require('utils.async').cmd(
    require('utils.env').nix_store_query('ds-pinyin-lsp'),
    function(out)
      require('utils.lsp').setup('ds_pinyin_lsp', {
        init_options = {
          db_path = vim.fs.joinpath(out, 'lib', 'dict.db3'),
          completion_on = true,
          match_as_same_as_input = true,
        },
      })
    end
  )
end
