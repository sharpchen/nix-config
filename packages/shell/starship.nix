{pkgs, ...}:
{
  home.packages = with pkgs;[
    starship
  ];

  xdg.configFile."startship.toml" = {
    source = ../dotfiles/starship.toml;
  };

}
