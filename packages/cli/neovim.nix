{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.neovim = {
    enable = true;
    plugins = [
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    ];
    extraWrapperArgs =
      let
        nvim-treesitter-parsers =
          let
            nvim-treesitter = pkgs.vimPlugins.nvim-treesitter;
          in
          builtins.map (grammar: nvim-treesitter.grammarToPlugin grammar) nvim-treesitter.allGrammars;
      in
      [
        "--set"
        "NVIM_TREESITTER_PARSERS"
        (lib.concatStringsSep "," nvim-treesitter-parsers)
      ];
  };

  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/nvim-config";
  };

  home.file.".vimrc".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/.vimrc";
}
