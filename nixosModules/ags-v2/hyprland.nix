{...}: {
  wayland.windowManager.hyprland = {
    settings = {
      animations = {
        bezier = [
          "easeInOutQuart, 0.77, 0   , 0.175, 1"
          "easeInExpo    , 0.95, 0.05, 0.795, 0.035"
        ];

        animation = [
          "fadeLayersIn , 0"
          "fadeLayersOut, 1, 3000, easeInExpo"
          "layers       , 1, 4   , easeInOutQuart, slide left"
        ];
      };

      layerrule = [
        "noanim, ^(?!win-).*"

        # Lockscreen blur
        "blur, ^(blur-bg.*)"
        "ignorealpha 0.19, ^(blur-bg.*)"
      ];

      exec-once = ["ags"];

      bind = [
        "$mainMod SHIFT, E    , exec, ags toggle win-powermenu"
        "$mainMod      , D    , exec, ags toggle win-applauncher"
        "$mainMod      , V    , exec, ags toggle win-clipboard"
        "              , Print, exec, ags toggle win-screenshot"
      ];
      binde = [
        ## Brightness control
        ", XF86MonBrightnessUp  , exec, ags request 'Brightness.screen += 0.05'"
        ", XF86MonBrightnessDown, exec, ags request 'Brightness.screen -= 0.05'"

        ## Volume control
        ", XF86AudioRaiseVolume , exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ & ags request 'popup_osd(\"speaker\")' &"
        ", XF86AudioLowerVolume , exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- & ags request 'popup_osd(\"speaker\")' &"
      ];
      bindn = ["    , Escape   , exec, ags request 'closeAll()'"];
      bindr = ["CAPS, Caps_Lock, exec, ags request 'Brightness.fetchCapsState()'"];
    };
  };
}
