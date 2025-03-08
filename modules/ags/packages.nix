self: {
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (self.inputs) gtk-session-lock kompass;

  inherit (lib) attrValues boolToString filter getExe mkIf optionalAttrs optionals;

  inherit (osConfig.networking) hostName;

  cfg = config.programs.ags;
  cfgDesktop = osConfig.roles.desktop;
  gtk4ConfigDir = "${cfg.configDir}/../gtk4";

  mainPkg = pkgs.writeShellApplication {
    name = "ags";
    runtimeInputs = [cfg.package];
    text = ''
      if [ "$#" == 0 ]; then
          exec ags run ~/${cfg.configDir} -a ${hostName}
      else
          exec ags "$@"
      fi
    '';
  };
in {
  config = mkIf cfgDesktop.ags.enable {
    # Make these accessible outside these files
    programs.ags = {
      package = pkgs.ags.override {
        extraPackages = cfg.astalLibs;
      };

      astalLibs = attrValues {
        inherit
          (pkgs.astalLibs)
          io
          astal3
          astal4
          apps
          auth
          battery
          bluetooth
          greet
          hyprland
          mpris
          network
          notifd
          powerprofiles
          tray
          wireplumber
          ;

        # TODO: switch to Gtk4 version to get rid of this dep
        gtkSessionLock = gtk-session-lock.packages.${pkgs.system}.default;

        # TODO: add overlays to upstream flake
        libKompass = kompass.packages.${pkgs.system}.libkompass;

        # libkompass dependencies
        inherit
          (pkgs.astalLibs)
          cava
          river
          ;

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
          if [ "$#" == 0 ]; then
              exec ags run ~/${cfg.configDir} -a lock
          else
              exec ags "$@" -i lock
          fi
        '';
      };
    };

    home = {
      packages =
        [
          mainPkg
          (pkgs.writeShellApplication {
            name = "ags4";
            runtimeInputs = [cfg.package];
            text = ''
              gsettings set org.gnome.desktop.interface cursor-size 30
              exec ags run ~/${gtk4ConfigDir}/app.ts --gtk4
            '';
          })
          (pkgs.writeShellApplication {
            name = "agsConf";
            runtimeInputs = [cfg.package];
            text = ''
              exec ags run ~/${cfg.configDir} -a "$1"
            '';
          })
        ]
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
          (self.lib.${pkgs.system})
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
        // (import ./icons.nix {
          inherit pkgs;
          agsConfigDir = gtk4ConfigDir;
        })
        // (buildGirTypes {
          pname = "ags";
          configPath = "${cfg.configDir}/@girs";
          packages = filter (x:
            true
            && x.pname != "libadwaita"
            && x.pname != "libkompass"
            && x.pname != "gtk4-layer-shell"
            && x.pname != "gtk4-session-lock")
          cfg.astalLibs;
        })
        // (buildGirTypes {
          pname = "ags";
          configPath = "${gtk4ConfigDir}/@girs";
          packages = filter (x:
            x.pname != "gtk-session-lock")
          cfg.astalLibs;
        })
        // {
          "${cfg.configDir}/node_modules" = {
            force = true;
            source = buildNodeModules ./config (import ./config).npmDepsHash;
          };

          "${gtk4ConfigDir}/node_modules" = {
            force = true;
            source = buildNodeModules ./config (import ./config).npmDepsHash;
          };

          "${cfg.configDir}/widgets/lockscreen/vars.ts".text = lockscreenVars;
          "${gtk4ConfigDir}/widgets/lockscreen/vars.ts".text = lockscreenVars;
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
