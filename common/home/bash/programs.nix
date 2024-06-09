{
  pkgs,
  config,
  self,
  ...
}: {
  programs = {
    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    bash = {
      sessionVariables = {
        inherit (config.home.sessionVariables) RIPGREP_CONFIG_PATH;
      };

      shellAliases = {
        rg = "rga";
        cat = "bat ";
        man = "BAT_THEME='default' batman ";
      };
    };

    ripgrep = {
      enable = true;
      package = pkgs.ripgrep-all;

      arguments = [
        "--max-columns=150"
        "--max-columns-preview"
        "--hidden"
        "--glob=!.git/*"
        "--smart-case"
        "--sort"
        "path"
      ];
    };

    jq.enable = true;
    htop.enable = true;

    bat = {
      enable = true;

      config.theme = "dracula-bat";
      themes.dracula-bat.src = self.packages.${pkgs.system}.dracula.bat;

      extraPackages = with pkgs.bat-extras; [
        batman
      ];
    };
  };
}
