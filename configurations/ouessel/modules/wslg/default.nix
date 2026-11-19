{
  lib,
  mainUser,
  pkgs,
  ...
}: let
  inherit (lib) attrNames concatMapStringsSep concatStringsSep getExe' mapAttrsToList mkForce;

  cursorTheme = "Windows";
  cursorMap = {
    aero_arrow = ["default" "left_ptr" "arrow" "top_left_arrow" "context-menu" "copy" "alias"];
    aero_working = ["progress" "left_ptr_watch" "half-busy"];
    aero_busy = ["wait" "watch"];
    beam_r = ["text" "xterm" "ibeam" "vertical-text"];
    cross_r = ["crosshair" "cross" "tcross" "cell"];
    aero_link = ["pointer" "hand" "hand1" "hand2" "pointing_hand"];
    aero_helpsel = ["help" "question_arrow" "whats_this"];
    aero_unavail = ["not-allowed" "no-drop" "forbidden" "crossed_circle"];
    aero_move = ["move" "all-scroll" "fleur" "size_all"];
    aero_ns = ["ns-resize" "n-resize" "s-resize" "row-resize" "size_ver" "sb_v_double_arrow" "v_double_arrow" "top_side" "bottom_side"];
    aero_ew = ["ew-resize" "e-resize" "w-resize" "col-resize" "size_hor" "sb_h_double_arrow" "h_double_arrow" "left_side" "right_side"];
    aero_nwse = ["nwse-resize" "nw-resize" "se-resize" "size_fdiag" "top_left_corner" "bottom_right_corner"];
    aero_nesw = ["nesw-resize" "ne-resize" "sw-resize" "size_bdiag" "top_right_corner" "bottom_left_corner"];
    aero_up = ["up-arrow" "center_ptr"];
    aero_pen = ["pencil"];
  };

  winCursors = "/mnt/c/Windows/Cursors";
in {
  programs.dconf.enable = true;

  wsl.startMenuLaunchers = true;

  # Start user when WSL is launched from Windows start menu
  users.users.${mainUser}.linger = true;

  # NixOS-WSL bind-mounts the X0 socket *file* into /tmp/.X11-unix, which goes
  # stale (points to a deleted inode) whenever WSLg restarts. It also stops
  # WSL's generated wslg.service (skipped if X0 exists) from binding the whole
  # directory over the tmpfs /tmp, which survives WSLg restarts.
  systemd.units."tmp-.X11\\x2dunix-X0.mount".enable = mkForce false;

  home-manager.users.${mainUser} = {
    config,
    lib,
    ...
  }: let
    themeDir = "${config.xdg.dataHome}/icons/${cursorTheme}";
  in {
    gtk = {
      enable = true;

      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };

      # wsl.startMenuLaunchers also moves the theme in /usr/lib which takes too long
      iconTheme = {
        name = "Flat-Remix-Violet-Dark";
        package = null;
      };

      cursorTheme = {
        name = cursorTheme;
        size = 24;
      };

      gtk3.extraConfig."gtk-application-prefer-dark-theme" = 1;
      gtk4.extraConfig."gtk-application-prefer-dark-theme" = 1;
    };

    home.sessionVariables = {
      XCURSOR_THEME = cursorTheme;
      XCURSOR_SIZE = 24;
    };

    # The Windows cursors are proprietary, so they are converted from the
    # local Windows install instead of being packaged. Only convert when
    # the theme is outdated.
    home.activation.windowsCursors = let
      convert = pkgs.writeShellScript "convert-windows-cursors" ''
        set -e
        rm -rf ${themeDir}
        mkdir -p ${themeDir}/cursors

        ${getExe' pkgs.win2xcur "win2xcur"} --shadow --output ${themeDir}/cursors \
          ${concatStringsSep " " (map (f: "${winCursors}/${f}.*") (attrNames cursorMap))}

        ${concatStringsSep "\n" (mapAttrsToList (src: names:
          concatMapStringsSep "\n" (n: "ln -sf ${src} ${themeDir}/cursors/${n}") names)
        cursorMap)}

        printf '[Icon Theme]\nName=${cursorTheme}\nInherits=Adwaita\n' > ${themeDir}/index.theme
        echo "$0" > ${themeDir}/.stamp
      '';
    in
      lib.hm.dag.entryAfter ["writeBoundary"] ''
        if [ -d ${winCursors} ] && [ "$(cat ${themeDir}/.stamp 2>/dev/null)" != "${convert}" ]; then
            run ${convert}
        fi
      '';
  };
}
