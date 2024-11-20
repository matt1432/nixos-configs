self: {pkgs, ...}: {
  config = let
    inherit (self.scopedPackages.${pkgs.system}) mpvScripts;
  in {
    # For kdialog-open-files
    home.packages = [
      pkgs.kdialog
    ];

    programs.mpv = {
      enable = true;

      # https://github.com/mpv-player/mpv/wiki/User-Scripts
      scripts = builtins.attrValues {
        inherit
          (mpvScripts)
          modernx
          persist-properties
          undo-redo
          ;

        # touch-gestures & deps
        inherit
          (mpvScripts)
          pointer-event
          touch-gestures
          ;

        # Ctrl + o
        inherit (mpvScripts) kdialog-open-files;
      };

      scriptOpts = {
        persist_properties = {
          properties = "volume,sub-scale";
        };

        # Touch gestures default
        pointer-event = {
          margin_left = 0;
          margin_right = 80;
          margin_top = 50;
          margin_bottom = 130;
          ignore_left_single_long_while_window_dragging = true;
          left_single = "cycle pause";
          left_double = "script-message-to touch_gestures double";
          left_long = "script-binding uosc/menu-blurred";
          left_drag_start = "script-message-to touch_gestures drag_start";
          left_drag_end = "script-message-to touch_gestures drag_end";
          left_drag = "script-message-to touch_gestures drag";
        };

        touch-gestures = {
          # valid options are:
          # 'playlist' for changing the playlist item by swiping
          # 'seek' for seeking by dragging
          horizontal_drag = "seek";

          # scale seeking based on the duration of the video
          proportional_seek = true;

          # scale factor for seeking
          seek_scale = 1;
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./mpv.nix;
}
