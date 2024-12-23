# nix-config

## Install on New Unix Machine

- [install nix](https://nixos.org/download/)

- enable flakes

multi-user

```sh
sudo sh -c 'echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf'
```

- add home-manager channel

```sh
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager && nix-channel --update
```

- install home-manager

```sh
nix-shell '<home-manager>' -A install
```

- clone repo

```sh
mkdir -p ~/.config/home-manager/ && \
rm -rf ~/.config/home-manager/* && \
curl -L https://github.com/sharpchen/nix-config/archive/refs/heads/main.tar.gz \
| tar -xz -C ~/.config/home-manager/ --strip-components=1
```

- restore

```sh
home-manager switch --flake ~/.config/home-manager#$USER
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

