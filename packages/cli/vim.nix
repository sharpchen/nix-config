{ pkgs, ... }:
{
  home.packages = [
    (pkgs.vim.overrideAttrs (oldAttrs: {
      buildInputs = (oldAttrs.buildInputs ++ [ pkgs.xorg.libX11 pkgs.xorg.libXt ]);
    }))
  ];

  home.file.".vimrc".source = ../../dotfiles/.vimrc;
  home.sessionVariables = {
    MYVIMRC = "~/.vimrc";
  };
}
