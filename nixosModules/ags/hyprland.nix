{...}: {
  wayland.windowManager.hyprland = {
    settings = {
      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 0;
      };

      decoration = {
        rounding = 12;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };

        shadow.enabled = false;
      };

      animations = {
        enabled = true;

        bezier = [
          "easeInQuart   , 0.895, 0.03, 0.685, 0.22"
          "easeOutQuart  , 0.165, 0.84, 0.44 , 1"
          "easeInOutQuart, 0.77, 0   , 0.175, 1"

          # Fade out
          "easeInExpo    , 0.95, 0.05, 0.795, 0.035"
        ];

        animation = [
          "workspaces, 1, 6, easeOutQuart, slide"

          "windows, 1, 4, easeOutQuart, slide"
          "fadeIn , 0"
          "fadeOut, 1, 3000, easeInExpo"

          "fadeLayersIn , 0"
          "fadeLayersOut, 1, 3000, easeInExpo"
          "layers       , 1, 4   , easeInOutQuart, slide left"
        ];
      };

      layerrule = [
        "animation popin, ^(hyprpaper.*)"
        "animation fade, ^(bg-layer.*)"

        # Lockscreen blur
        "blur, ^(blur-bg.*)"
        "ignorealpha 0.19, ^(blur-bg.*)"
      ];

      exec-once = [
        "ags"
        "sleep 3; ags request 'open win-applauncher'"
      ];

      bind = [
        "$mainMod SHIFT, E    , exec, ags toggle win-powermenu"
        "$mainMod      , D    , exec, ags toggle win-applauncher"
        "$mainMod      , V    , exec, ags toggle win-clipboard"
        "              , Print, exec, ags toggle win-screenshot"
      ];
      binde = [
        ## Brightness control
        ", XF86MonBrightnessUp  , exec, ags request 'Brightness.screen +0.05'"
        ", XF86MonBrightnessDown, exec, ags request 'Brightness.screen -0.05'"

        ## Volume control
        ", XF86AudioRaiseVolume , exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ & ags request 'popup speaker' &"
        ", XF86AudioLowerVolume , exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- & ags request 'popup speaker' &"
      ];
      bindn = ["    , Escape   , exec, ags request closeAll"];
      bindr = ["CAPS, Caps_Lock, exec, ags request fetchCapsState"];
    };
  };
}
