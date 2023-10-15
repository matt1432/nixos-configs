{ ... }: {
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
      ];
    };
    jq.enable = true;
  };
}
