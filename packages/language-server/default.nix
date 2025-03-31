{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      lua-language-server
      taplo
      nixd
      lemminx
      actionlint
      ast-grep
      nodePackages.bash-language-server
      nodePackages.yaml-language-server
      markdownlint-cli2
      vim-language-server
      harper
      ast-grep
      postgres-lsp
      sqlfluff
      eslint
      ruff
      bashdb
      marksman
      ts_query_ls
    ]
    ++ [
      (callPackage ./msbuild_ls/default.nix { inherit pkgs; })
      # (callPackage ./avalonia_ls/default.nix { inherit pkgs; })
    ];
}
