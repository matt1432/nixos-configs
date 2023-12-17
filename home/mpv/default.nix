{pkgs, ...}: {
  programs.mpv = {
    enable = true;

    scripts = with (import ./scripts pkgs); [
      modernx
      # Dep of touch-gestures
      pointer-event
      touch-gestures
    ];

    scriptOpts = {
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
}
