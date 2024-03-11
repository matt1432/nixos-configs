{
  config,
  hyprlock,
  lib,
  ...
}: let
  inherit (lib) optionalString;
  inherit (config.vars) mainMonitor;

  monitor = optionalString (mainMonitor != null) mainMonitor;
in {
  imports = [hyprlock.homeManagerModules.default];

  programs.hyprlock = {
    enable = true;
    general = {
      hide_cursor = false;
    };

    backgrounds = [
      {
        path = "screenshot";
        blur_size = 5;
        blur_passes = 2;
        vibrancy_darkness = 0.0;
        brightness = 1.0;
      }
    ];

    input-fields = [
      {
        inherit monitor;
        fade_on_empty = false;
        outer_color = "rgba(10, 10, 10, 1.0)";
        inner_color = "rgb(151515)";
        font_color = "rgba(240, 240, 240, 1.0)"; # This is the dot color
        placeholder_text = ''<span foreground="##cccccc" style="italic">Input Password...</span>'';
      }
    ];

    labels = [
      {
        inherit monitor;
        text = "$TIME";
        font_size = 80;
        font_family = "Ubuntu Mono";
        position.y = 240;
        shadow_passes = 3;
      }
      {
        inherit monitor;
        text = "<i> Groovy </i>";
        font_family = "Ubuntu Mono";
        shadow_passes = 3;
      }
    ];
  };
}
