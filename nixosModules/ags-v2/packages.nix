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

    # Astal libraries
    gtkSessionLock = gtk-session-lock.packages.${pkgs.system}.default;
    agsV2Packages = agsV2.packages.${pkgs.system};
    astalLibs = attrValues (removeAttrs agsV2.inputs.astal.packages.${pkgs.system} ["docs" "gjs"]) ++ [gtkSessionLock];

    # Final ags package
    agsFull = agsV2Packages.ags.override {extraPackages = astalLibs;};
  in {
    programs.ags-v2.lockPkg = pkgs.writeShellApplication {
      name = "lock";
      text = ''
        export CONF="lock"
        exec ${agsFull}/bin/ags --config ${agsConfigDir} "$@"
      '';
    };

    home = {
      packages =
        [
          (pkgs.writeShellApplication {
            name = "ags";
            text = ''
              export CONF="${hostName}"
              exec ${agsFull}/bin/ags --config ${agsConfigDir} "$@"
            '';
          })
          (pkgs.writeShellApplication {
            name = "agsConf";
            text = ''
              export CONF="$1"
              exec ${agsFull}/bin/ags --config ${agsConfigDir}
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
            buildNodeModules ./config "sha256-pK9S6qUjTIL0JDegYJlHSY5XEpLFKfA98MfZ59Q3IL4=";

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
