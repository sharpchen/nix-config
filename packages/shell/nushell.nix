{ pkgs, ... }:
{
  home.packages = with pkgs;[
    nushell
  ];

  home.file.".config/nushell/config.nu".text = /* nu */
      ''
        $env.config = {
          show_banner: false,
        }
      '';
}
