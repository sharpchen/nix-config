local lsp = require('utils.lsp')

lsp.setup('nixd', {
  on_init = function(client)
    lsp.event.disable_semantic(client)
    lsp.event.disable_formatter(client)
  end,
  settings = {
    nixd = {
      nixpkgs = {
        expr = 'import <nixpkgs> { }',
      },
      options = {
        nixos = {
          expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.nixos-wsl.options',
        },
        home_manager = {
          expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations.sharpchen.options',
        },
      },
    },
  },
})
