{
  programs.starship.enable = true;
  programs.starship.settings = {
    add_newline = true;
    shlvl = {
      disabled = false;
      style = "bright-red bold";
    };
    shell = {
      disabled = false;
      format = "$indicator";
      fish_indicator = "";
      bash_indicator = "[BASH](bright-white) ";
    };
    username = {
      style_user = "bright-white bold";
      style_root = "bright-red bold";
    };
    dotnet = {
      symbol  = ".NET SDK: ";
      format = " [$symbol($version )(targets $tfm )]($style)";
    };
    git_branch = {
      only_attached = true;
      format = "[$symbol$branch]($style) ";
      symbol = " ";
    };
  };
}
