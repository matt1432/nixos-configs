{ ... }: {
  programs = {
    fzf = {
      enable = true;
      enableBashIntegration = true;
    };
    ripgrep = {
      enable = true;
      arguments = [
        "--no-config"
      ];
    };
    jq.enable = true;
  };
}
