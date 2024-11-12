{
  self,
  agsConfigDir,
}: {
  lib,
  osConfig,
  pkgs,
  ...
}: {
  options.programs.ags-v2.lockPkg = lib.mkOption {
    type = with lib.types; nullOr package;
    default = null;
  };

  config = let
    # Inputs
    inherit (self.inputs) agsV2 gtk-session-lock;

    # Libs
    inherit (lib) attrValues boolToString optionals removeAttrs;

    # Cfg info
    inherit (osConfig.networking) hostName;
    cfgDesktop = osConfig.roles.desktop;
    fullConfPath = "/home/${cfgDesktop.user}/${agsConfigDir}";

    # Astal libraries
    gtkSessionLock = gtk-session-lock.packages.${pkgs.system}.default;
    agsV2Packages = agsV2.packages.${pkgs.system};
    astalLibs = attrValues (removeAttrs agsV2.inputs.astal.packages.${pkgs.system} ["docs" "gjs"]) ++ [gtkSessionLock];

    # Final ags package
    agsFull = agsV2Packages.ags.override {extraPackages = astalLibs;};
  in {
    programs.ags-v2.lockPkg = pkgs.writeShellApplication {
      name = "lock";
      runtimeInputs = [agsFull];
      text = ''
        export CONF="lock"

        if [ "$#" == 0 ]; then
          exec ags run ${fullConfPath}
        else
          exec ags "$@" -i lock
        fi
      '';
    };

    home = {
      packages =
        [
          (pkgs.writeShellApplication {
            name = "ags";
            runtimeInputs = [agsFull];
            text = ''
              export CONF="${hostName}"

              if [ "$#" == 0 ]; then
                exec ags run ${fullConfPath}
              else
                exec ags "$@"
              fi
            '';
          })
          (pkgs.writeShellApplication {
            name = "agsConf";
            runtimeInputs = [agsFull];
            text = ''
              export CONF="$1"
              exec ${agsFull}/bin/ags run ${fullConfPath}
            '';
          })
        ]
        ++ (builtins.attrValues {
          inherit
            (pkgs)
            playerctl
            pavucontrol # TODO: replace with ags widget
            ;
        })
        ++ (optionals cfgDesktop.isTouchscreen (builtins.attrValues {
          inherit
            (pkgs)
            ydotool
            ;
        }));

      file = let
        inherit
          (import "${self}/lib" {inherit pkgs self;})
          buildNodeModules
          buildNodeTypes
          ;
      in (
        (buildNodeTypes {
          pname = "agsV2";
          configPath = "${agsConfigDir}/@girs";
          packages = astalLibs;
        })
        // {
          "${agsConfigDir}/node_modules".source =
            buildNodeModules ./config "sha256-cyVdjRV1o/UvAPzXigNzXATq1mRmsXhDqnG4wnBzSXE=";

          "${agsConfigDir}/tsconfig.json".source = pkgs.writers.writeJSON "tsconfig.json" {
            "$schema" = "https://json.schemastore.org/tsconfig";
            "compilerOptions" = {
              "experimentalDecorators" = true;
              "strict" = true;
              "target" = "ES2023";
              "moduleResolution" = "Bundler";
              "jsx" = "react-jsx";
              "jsxImportSource" = "${agsV2Packages.gjs}/share/astal/gjs/gtk3";
              "paths" = {
                "astal" = ["${agsV2Packages.gjs}/share/astal/gjs"];
                "astal/*" = ["${agsV2Packages.gjs}/share/astal/gjs/*"];
              };
              "skipLibCheck" = true;
              "module" = "ES2022";
              "lib" = ["ES2023"];
            };
          };

          "${agsConfigDir}/widgets/lockscreen/vars.ts".text =
            # javascript
            ''
              export default {
                  mainMonitor: '${cfgDesktop.mainMonitor}',
                  dupeLockscreen: ${boolToString cfgDesktop.displayManager.duplicateScreen},
                  hasFprintd: ${boolToString (hostName == "wim")},
              };
            '';
        }
      );
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
