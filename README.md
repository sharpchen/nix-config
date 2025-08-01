## Nix Config

## Prerequisites

### Non-NixOS Prerequisites

1. [install nix](https://nixos.org/download/)

2. enable flakes

```sh
sudo sh -c 'echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf'
```

### Common Prerequisites

1. add home-manager channel

```sh
nix-channel --add https://nixos.org/channels/nixos-unstable nixpkgs
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```

2. install home-manager as standalone

```sh
nix-shell '<home-manager>' -A install
```

3. clone repo

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
pwsh -noprofile -f ./install.ps1
```

### Dotfiles only

```sh
pwsh -noprofile -f ./dotfiles.ps1
```

