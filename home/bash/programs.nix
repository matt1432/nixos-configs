{pkgs, ...}: {
  programs = {
    fzf = {
      enable = true;
      enableBashIntegration = true;
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
          src = pkgs.fetchFromGitHub {
            owner = "matt1432";
            repo = "bat";
            rev = "270bce892537311ac92494a2a7663e3ecf772092";
            hash = "sha256-UyZ3WFfrEEBjtdb//5waVItmjKorkOiNGtu9eeB3lOw=";
          };
          file = "Dracula.tmTheme";
        };
      };
      extraPackages = with pkgs.bat-extras; [
        batman
      ];
    };
  };
}
