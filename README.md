## Nix Config

## Prerequisites

### Non-NixOS Prerequisites

- [install nix](https://nixos.org/download/)

### Common Prerequisites

1. Enable flakes

```sh
sudo sh -c 'echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf'
```

2. Clone repo

```sh
nix-shell -p git
mkdir -p ~/.config/home-manager/ && cd ~/.config/home-manager/ && git clone https://github.com/sharpchen/nix-config.git .
```

## Installation


### NixOS-WSL

```sh
sudo nixos-rebuild switch --flake ~/.config/home-manager#nixos-wsl
```

### Non-NixOS


```sh
home-manager switch --flake ~/.config/home-manager#sharpchen
```

## Restore on Windows

### Whole machine

```sh
powershell -noprofile -f ./install.ps1
```

### Dotfiles only

```sh
powershell -noprofile -f ./dotfiles.ps1
```

