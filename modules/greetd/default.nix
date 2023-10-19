{ lib
, pkgs
, config
, hyprland
, ...
}: let
  regreetBin = "${lib.getExe config.programs.regreet.package}";
  hyprBin = "${hyprland.packages.x86_64-linux.default}/bin";
  gset = pkgs.gsettings-desktop-schemas;

  css = pkgs.writeText "style.css" ''
    window {
      background-color: rgba(0, 0, 0, 0);
    }
  '';

  paperConf = pkgs.writeText "hyprpaper.conf" ''
    preload = ${pkgs.dracula-theme}/wallpapers/waves.png
    wallpaper = eDP-1, ${pkgs.dracula-theme}/wallpapers/waves.png
  '';

  hyprConf = pkgs.writeText "greetd-hypr-config" ''
    exec-once = hyprpaper --config ${paperConf}

    input {
        kb_layout = ca
        kb_variant = multix
        kb_model =
        kb_options =
        kb_rules =

        follow_mouse = 1

        touchpad {
            natural_scroll = yes
        }
        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
    }

    env = XCURSOR_SIZE,24
    exec-once=hyprctl setcursor Dracula-cursors 24

    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        vfr = true
    }

    general {
        border_size = 0
    }

    decoration {
        blur {
            enabled = false
        }
        drop_shadow = false
    }

    # FIXME: kb doesn't work
    env = XDG_DATA_DIRS, ${gset}/share/gsettings-schemas/${gset.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS
    exec-once = squeekboard
    exec-once = gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true

    exec-once = ${regreetBin} -s ${css}; ${hyprBin}/hyprctl dispatch exit
  '';
in {
  users.users.greeter = {
    packages = with pkgs; [
      dracula-theme
      flat-remix-icon-theme
      hyprpaper
      gtk3
      glib
      squeekboard
    ];
  };

  # See overlay
  programs.regreet = {
    enable = true;
    settings = {
      GTK = {
        cursor_theme_name = "Dracula-cursors";
        font_name = "Sans Serif";
        icon_theme_name = "Flat-Remix-Violet-Dark";
        theme_name = "Dracula";
      };
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${hyprBin}/Hyprland --config ${hyprConf}";
        user = "greeter";
      };
    };
  };

  # unlock GPG keyring on login
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
