self: {
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (self.inputs) ags gtk-session-lock;

  gtkSessionLock = gtk-session-lock.packages.${pkgs.system}.default;

  inherit (lib) attrValues boolToString getExe optionalAttrs optionals;

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
  config = {
    # Make these accessible outside these files
    programs.ags = {
      package = ags.packages.${pkgs.system}.ags.override {
        extraPackages = cfg.astalLibs;
      };
      astalLibs = attrValues {
        inherit
          (ags.inputs.astal.packages.${pkgs.system})
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

        inherit gtkSessionLock;

        inherit
          (pkgs)
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

        mkTsConf = gtkVer: let
          inherit (ags.packages.${pkgs.system}) gjs;
        in
          pkgs.writers.writeJSON "tsconfig.json" {
            "$schema" = "https://json.schemastore.org/tsconfig";
            "compilerOptions" = {
              "experimentalDecorators" = true;
              "strict" = true;
              "target" = "ES2022";
              "module" = "ES2022";
              "moduleResolution" = "Bundler";
              "noEmit" = true;
              "jsx" = "react-jsx";
              "jsxImportSource" = "${gjs}/share/astal/gjs/gtk${toString gtkVer}";
              "paths" = {
                "astal" = ["${gjs}/share/astal/gjs"];
                "astal/*" = ["${gjs}/share/astal/gjs/*"];
              };
            };
          };
      in (
        (buildGirTypes {
          pname = "ags";
          configPath = "${cfg.configDir}/@girs";
          packages = cfg.astalLibs;
        })
        // (buildGirTypes {
          pname = "ags";
          configPath = "${gtk4ConfigDir}/@girs";
          packages = cfg.astalLibs;
        })
        // {
          "${cfg.configDir}/node_modules".source =
            buildNodeModules ./config (import ./config).npmDepsHash;

          "${gtk4ConfigDir}/node_modules".source =
            buildNodeModules ./config (import ./config).npmDepsHash;

          "${cfg.configDir}/tsconfig.json".source = mkTsConf 3;

          "${gtk4ConfigDir}/tsconfig.json".source = mkTsConf 4;

          "${cfg.configDir}/widgets/lockscreen/vars.ts".text =
            # javascript
            ''
              export default {
                  mainMonitor: '${cfgDesktop.mainMonitor}',
                  dupeLockscreen: ${boolToString cfgDesktop.displayManager.duplicateScreen},
                  hasFprintd: ${boolToString (hostName == "wim")},
              };
            '';
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
