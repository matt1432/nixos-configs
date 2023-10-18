# Home-manager module

{ pkgs, ... }: {
  programs = {

    git = {
      enable = true;
      lfs.enable = true;

      userName = "matt1432";
      userEmail = "matt@nelim.org";

      includes = [
        { path = "${pkgs.dracula-theme}/git-colors"; }
      ];
    };
  };
}
