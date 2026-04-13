{
  imports = [
    ./misc.nix
    ./git.nix
    ./neovim.nix
    # ./vim.nix
    # ./tmux.nix
    ./yazi.nix

    ./dev/default.nix
    ./shell/default.nix
    ./formatter/default.nix
    ./language-server/default.nix
  ];
}
