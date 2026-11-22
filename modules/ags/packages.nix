self: {
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (self.inputs) ags astal;

  inherit (lib) attrValues boolToString getExe mkIf optionalAttrs optionals;

  inherit (osConfig.networking) hostName;
  inherit (pkgs.stdenv.hostPlatform) system;

  cfg = config.programs.ags;
  cfgDesktop = osConfig.roles.desktop;

  mainPkg = pkgs.writeShellApplication {
    name = "ags";
    runtimeInputs = [cfg.package];
    text = ''
      gsettings set org.gnome.desktop.interface cursor-size 30

      if [ "$#" == 0 ]; then
          exec ags run ~/${cfg.configDir}/app.ts --gtk 4 ${hostName}
      else
          exec ags "$@"
      fi
    '';
  };
in {
  config = mkIf cfgDesktop.ags.enable {
    # Make these accessible outside these files
    programs.ags = {
      package = ags.packages.${system}.ags.override {
        extraPackages = cfg.astalLibs;
        inherit (pkgs) gtk4-layer-shell;
      };

      astalLibs = attrValues {
        inherit
          (astal.packages.${system})
          io
          astal4
          apps
          auth
          battery
          bluetooth
          cava
          greet
          mpris
          network
          notifd
          powerprofiles
          tray
          wireplumber
          wl # needed by workspace
          workspace
          ;

        # NOTE: remove once astal supports Hyprland 0.56 workspace addresses
        hyprland = astal.packages.${system}.hyprland.overrideAttrs (o: {
          patches = (o.patches or []) ++ [./astal-hyprland-0.56.patch];
        });

        inherit
          (pkgs)
          libadwaita
          gtk4-layer-shell
          gtk4 # Needed to build types
          ;
      };

      lockPkg = pkgs.writeShellApplication {
        name = "lock";
        runtimeInputs = [cfg.package];
        text = ''
          gsettings set org.gnome.desktop.interface cursor-size 30

          if [ "$#" == 0 ]; then
              exec ags run ~/${cfg.configDir}/app.ts --gtk 4 lock
          else
              exec ags "$@" -i lock
          fi
        '';
      };
    };

    home = {
      packages =
        [mainPkg]
        ++ (attrValues {
          inherit
            (pkgs)
            networkmanagerapplet
            playerctl
            wayfreeze
            ;
          inherit
            (pkgs.selfPackages)
            coloryou
            ;
        })
        ++ (optionals cfgDesktop.isTouchscreen (attrValues {
          inherit
            (pkgs)
            ydotool
            ;
        }));

      file = let
        inherit
          (self.lib.${pkgs.stdenv.hostPlatform.system})
          buildNodeModules
          buildGirTypes
          ;

        lockscreenVars =
          # javascript
          ''
            export default {
                mainMonitor: '${cfgDesktop.mainMonitor}',
                dupeLockscreen: ${boolToString cfgDesktop.displayManager.duplicateScreen},
                hasFprintd: ${boolToString (hostName == "wim")},
            };
          '';
      in (
        (import ./icons.nix {
          inherit pkgs;
          agsConfigDir = cfg.configDir;
        })
        // (buildGirTypes {
          pname = "ags";
          configPath = "${cfg.configDir}/@girs";
          packages = cfg.astalLibs;
        })
        // {
          "${cfg.configDir}/node_modules" = {
            force = true;
            source = buildNodeModules ./config (import ./config).npmDepsHash;
          };

          "${cfg.configDir}/widgets/lockscreen/vars.ts".text = lockscreenVars;
        }
        // optionalAttrs cfgDesktop.isTouchscreen {
          ".config/fcitx5/conf/virtualkeyboardadapter.conf".text = ''
            ActivateCmd="${getExe mainPkg} request 'show-osk'"
            DeactivateCmd="${getExe mainPkg} request 'hide-osk'"
          '';
        }
      );
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
