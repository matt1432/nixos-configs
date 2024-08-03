self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.inputs) ags;
in {
  config = let
    cfg = config.roles.desktop;

    hyprland =
      config
      .home-manager
      .users
      .${cfg.user}
      .wayland
      .windowManager
      .hyprland
      .finalPackage;
  in {
    # Add home folder for home-manager to work
    users.users.greeter = {
      home = "/var/lib/greeter";
      createHome = true;
    };

    home-manager.users.greeter = {
      imports = [ags.homeManagerModules.default];

      programs.ags.enable = true;

      home.packages = [
        hyprland
        pkgs.gtk3
        pkgs.glib
      ];

      xdg.configFile = {
        "ags".source = pkgs.stdenv.mkDerivation {
          name = "ags-greeter";
          src = lib.fileset.toSource {
            root = ./.;
            fileset = lib.fileset.unions [
              ./scss
              ./greeter.ts
              ./ts
              ./tsconfig.json
            ];
          };

          buildInputs = with pkgs; [
            bun
            dart-sass
          ];

          buildPhase = ''
            sass ./scss/greeter.scss style.css
            bun build ./greeter.ts \
              --external resource:///* \
              --external gi://* \
              --external cairo > config.js
          '';

          installPhase = ''
            mkdir $out
            mv style.css config.js $out/
          '';
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
