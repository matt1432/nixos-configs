self: {
  lib,
  osConfig,
  pkgs,
  ...
}: {
  config = let
    inherit (lib) attrValues boolToString removeAttrs;

    inherit (osConfig.vars) hostName;
    cfgDesktop = osConfig.roles.desktop;

    inherit (self.inputs) agsV2 gtk-session-lock;

    gtkSessionLock = gtk-session-lock.packages.${pkgs.system}.default;

    agsV2Packages = agsV2.packages.${pkgs.system};
    astalLibs = attrValues (removeAttrs agsV2.inputs.astal.packages.${pkgs.system} ["docs" "gjs"]) ++ [gtkSessionLock];
    agsFull = agsV2Packages.ags.override {extraPackages = astalLibs;};
    configDir = "/home/matt/.nix/nixosModules/ags/v2";
  in {
    home = {
      packages = [
        (pkgs.writeShellApplication {
          name = "agsV2";
          text = ''
            export CONF="wim"
            exec ${agsFull}/bin/ags --config ${configDir} "$@"
          '';
        })
        (pkgs.writeShellApplication {
          name = "agsConf";
          text = ''
            export CONF="$1"
            exec ${agsFull}/bin/ags --config ${configDir}
          '';
        })
      ];

      file = let
        inherit
          (import "${self}/lib" {inherit pkgs self;})
          buildNodeModules
          buildNodeTypes
          ;
      in (
        (buildNodeTypes {
          pname = "agsV2";
          configPath = "${configDir}/@girs";
          packages = astalLibs;
        })
        // {
          "${configDir}/node_modules".source =
            buildNodeModules ./. "sha256-f0hbPvHTqeFM7mfmV+sN4EEuE0F91f5kjJ/EHy0oU+Y=";

          "${configDir}/tsconfig.json".source = pkgs.writers.writeJSON "tsconfig.json" {
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

          "${configDir}/widgets/lockscreen/vars.ts".text =
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
