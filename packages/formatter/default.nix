{ pkgs, ... }:
{
  home.packages = with pkgs;[
    nodePackages.prettier
    stylua
    csharpier
    shfmt
  ];

  home.file.".prettierrc".text = /* json */
    ''
      {
        "singleQuote": true,
        "tabWidth": 2,
        "semi": true,
        "htmlWhitespaceSensitivity": "ignore",
        "vueIndentScriptAndStyle": true,
        "arrowParens": "avoid",
        "printWidth": 100,
        "trailingComma": "all"
      }
    '';
}
