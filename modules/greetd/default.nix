{ lib
, pkgs
, config
, ...
}: let
  sway = "${config.programs.sway.package}/bin/sway";
  swayConf = pkgs.writeText "greetd-sway-config" ''
    exec "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP"
    input "type:touchpad" {
      tap enabled
    }
    seat seat0 xcursor_theme Dracula-cursors 24
    xwayland disable

    default_border none
    default_floating_border none
    font pango:monospace 0
    titlebar_padding 1
    titlebar_border_thickness 0

    exec "${lib.getExe config.programs.regreet.package} -l debug; swaymsg exit"
  '';
in {
  environment.systemPackages = with pkgs; [
    dracula-theme
    flat-remix-icon-theme
  ];

  programs.regreet = {
    enable = true;
    package = pkgs.greetd.regreet.overrideAttrs (self: super: rec {
      version = "0.1.1-patched";
      src = pkgs.fetchFromGitHub {
        owner = "rharish101";
        repo = "ReGreet";
        rev = "61d871a0ee5c74230dfef8100d0c9bc75b309203";
        hash = "sha256-PkQTubSm/FN3FXs9vBB3FI4dXbQhv/7fS1rXkVsTAAs=";
      };
      cargoDeps = super.cargoDeps.overrideAttrs (_: {
        inherit src;
        outputHash = "sha256-dR6veXCGVMr5TbCvP0EqyQKTG2XM65VHF9U2nRWyzfA=";
      });

      # temp fix until https://github.com/rharish101/ReGreet/issues/32 is solved
      patches = [./regreet.patch];
    });

    settings = {
      background = {
        path = "${pkgs.dracula-theme}/wallpapers/waves.png";
        fit = "Cover";
      };
      GTK = {
        cursor_theme_name = "Dracula-cursors";
        font_name = "Sans Serif";
        icon_theme_name = "Flat-Remix-Violet-Dark";
        theme_name = "Dracula";
      };
    };
  };

  programs.sway.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${sway} --config ${swayConf}";
        user = "greeter";
      };
    };
  };

  # unlock GPG keyring on login
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
