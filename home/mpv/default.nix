{pkgs, ...}: let
  mpvScripts = import ./scripts pkgs;
in {
  programs.mpv = {
    enable = true;

    scripts = with mpvScripts; [
      modernx
    ];
  };
}
