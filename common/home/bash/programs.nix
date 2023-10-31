{ pkgs, ... }: {
  programs = {
    fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    ripgrep = {
      enable = true;
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

    bash.shellAliases = {
      cat = "bat ";
      man = "BAT_THEME='default' batman ";
    };
    bat = {
      enable = true;
      config = {
        theme = "dracula-bat";
      };
      themes = {
        dracula-bat = {
          src = "${pkgs.dracula-theme}/bat";
          file = "dracula-bat.tmTheme";
        };
      };
      extraPackages = with pkgs.bat-extras; [
        batman
      ];
    };
  };
}