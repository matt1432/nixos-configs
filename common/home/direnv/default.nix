{pkgs, ...}: {
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;

    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };
}
