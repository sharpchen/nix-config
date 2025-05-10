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
      vim-language-server
      ast-grep
      postgres-lsp
      sqlfluff
      eslint
      bashdb
      marksman
      ts_query_ls
    ]
    ++ [
      (callPackage ./msbuild_ls/default.nix { inherit pkgs; })
      # (callPackage ./avalonia_ls/default.nix { inherit pkgs; })
    ];
}
