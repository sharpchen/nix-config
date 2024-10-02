# nix-config

## Install on New Machine

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
git clone https://github.com/sharpchen/nix-config.git ~/.config/home-manager/
```

- restore

```sh
home-manager switch --flake .#sharpchen
```
