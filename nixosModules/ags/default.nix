self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.inputs) ags astal gtk-session-lock;
in {
  config = let
    inherit (lib) boolToString mkIf;

    # Configs
    inherit (config.vars) hostName;
    cfgDesktop = config.roles.desktop;
    flakeDir = config.environment.variables.FLAKE;

    # Packages
    astalTray = astal.packages.${pkgs.system}.tray;
    gtkSessionLock = gtk-session-lock.packages.${pkgs.system}.default;
  in
    mkIf cfgDesktop.ags.enable {
      # Enable pam for ags
      security.pam.services.ags = {};

      services.upower.enable = true;

      home-manager.users.${cfgDesktop.user}.imports = [
        ags.homeManagerModules.default

        ({
          config,
          lib,
          ...
        }: let
          inherit (config.lib.file) mkOutOfStoreSymlink;
          inherit (lib) hasPrefix optionals removePrefix;

          configJs =
            # javascript
            ''
              Utils.execAsync('hyprpaper');

              import { transpileTypeScript } from './js/utils.js';

              export default (await transpileTypeScript('${hostName}')).default;
            '';

          agsPkg = config.programs.ags.finalPackage;
          agsConfigDir = "${removePrefix "/home/${cfgDesktop.user}/" flakeDir}/nixosModules/ags";
        in {
          assertions = [
            {
              assertion = hasPrefix "/home/${cfgDesktop.user}/" flakeDir;
              message = ''
                Your $FLAKE environment variable needs to point to a directory in
                the main users' home to use the AGS module.
              '';
            }
          ];

          imports = [(import ./v2 self)];

          programs.ags = {
            enable = true;
            extraPackages = [
              astalTray
              gtkSessionLock
            ];
          };

          home = {
            file = let
              inherit
                (import "${self}/lib" {inherit pkgs self;})
                buildNodeModules
                buildNodeTypes
                ;
            in (
              {
                # Generated types
                "${agsConfigDir}/config/types" = {
                  source = "${agsPkg}/share/com.github.Aylur.ags/types";
                  recursive = true; # To add other types inside the folder
                };
              }
              // (buildNodeTypes {
                pname = "gtk-session-lock";
                configPath = "${agsConfigDir}/config/types/@girs";
                packages = [gtkSessionLock];
              })
              // (buildNodeTypes {
                pname = "astal-tray";
                configPath = "${agsConfigDir}/config/types/@girs";
                packages = [astalTray];
              })
              // {
                # Out of store symlinks
                ".config/ags".source = mkOutOfStoreSymlink "${flakeDir}/nixosModules/ags/config";

                # Generated JavaScript files
                "${agsConfigDir}/config/config.js".text = configJs;
                "${agsConfigDir}/config/ts/lockscreen/vars.ts".text =
                  # javascript
                  ''
                    export default {
                        mainMonitor: '${cfgDesktop.mainMonitor}',
                        dupeLockscreen: ${boolToString cfgDesktop.displayManager.duplicateScreen},
                        hasFprintd: ${boolToString (hostName == "wim")},
                    };
                  '';

                "${agsConfigDir}/config/node_modules".source =
                  buildNodeModules ./config "sha256-4ybtwyZs7AgIYiGm1RuWwEgrnkxAqIEkPZjJJfQV/6I=";
              }
              // (import ./icons.nix {inherit pkgs agsConfigDir;})
            );

            packages =
              [
                (pkgs.callPackage ./clipboard {})
                # TODO: replace with matugen
                self.packages.${pkgs.system}.coloryou
              ]
              ++ (builtins.attrValues {
                inherit
                  (pkgs)
                  dart-sass
                  bun
                  playerctl
                  pavucontrol # TODO: replace with ags widget
                  ;
              })
              ++ (optionals cfgDesktop.isTouchscreen (builtins.attrValues {
                inherit
                  (pkgs)
                  lisgd
                  ydotool
                  ;
              }));
          };

          wayland.windowManager.hyprland = let
            runAgs = "pgrep ags -a | grep '/bin/gjs' && ags";
          in {
            settings = {
              animations = {
                bezier = [
                  "easeInOutBack,   0.68, -0.6, 0.32, 1.6"
                ];

                animation = [
                  "fadeLayersIn, 0"
                  "fadeLayersOut, 1, 3000, default"
                  "layers, 1, 8, easeInOutBack, slide left"
                ];
              };

              layerrule = [
                "noanim, ^(?!win-).*"

                # Lockscreen blur
                "blur, ^(blur-bg.*)"
                "ignorealpha 0.19, ^(blur-bg.*)"
              ];

              exec-once = [
                "ags"
                "sleep 3; ags -r 'App.openWindow(\"win-applauncher\")'"
              ];

              bind = [
                "$mainMod SHIFT, E    , exec, ${runAgs} -t win-powermenu"
                "$mainMod      , D    , exec, ${runAgs} -t win-applauncher"
                "$mainMod      , V    , exec, ${runAgs} -t win-clipboard"
                "              , Print, exec, ${runAgs} -t win-screenshot"
              ];
              binde = [
                ## Brightness control
                ", XF86MonBrightnessUp  , exec, ${runAgs} -r 'Brightness.screen += 0.05'"
                ", XF86MonBrightnessDown, exec, ${runAgs} -r 'Brightness.screen -= 0.05'"
              ];
              bindn = ["    , Escape   , exec, ${runAgs} -r 'closeAll()'"];
              bindr = ["CAPS, Caps_Lock, exec, ${runAgs} -r 'Brightness.fetchCapsState()'"];
            };
          };
        })
      ];
    };

  # For accurate stack trace
  _file = ./default.nix;
}
