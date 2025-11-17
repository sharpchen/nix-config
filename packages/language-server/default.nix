{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      emmylua-ls
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
      marksman
      ts_query_ls
    ]
    ++ [
      (callPackage ./msbuild_ls/package.nix { })
      (callPackage ./avalonia_ls/package.nix { })
      (callPackage ./ds_pinyin_lsp/package.nix { })
    ];
}
