self: {
  lib,
  pkgs,
  ...
}: {
  config = let
    inherit (lib) attrValues removeAttrs;

    inherit (self.inputs) agsV2;

    agsV2Packages = agsV2.packages.${pkgs.system};
    astalLibs = attrValues (removeAttrs agsV2.inputs.astal.packages.${pkgs.system} ["docs"]);
    configDir = "/home/matt/.nix/nixosModules/ags/v2";
  in {
    home = {
      packages = [
        (pkgs.writeShellApplication {
          name = "agsV2";
          runtimeInputs = [];
          text = ''
            exec ${agsV2Packages.agsFull}/bin/ags --config ${configDir} "$@"
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
            buildNodeModules ./. "sha256-u2LDbIKA32urN/NqqJrdAl46pUloPaoa5HoYDRJDh1k=";

          "${configDir}/tsconfig.json".source = pkgs.writers.writeJSON "tsconfig.json" {
            "$schema" = "https://json.schemastore.org/tsconfig";
            "compilerOptions" = {
              "target" = "ES2023";
              "module" = "ES2022";
              "lib" = ["ES2023"];
              "strict" = true;
              "moduleResolution" = "Bundler";
              "skipLibCheck" = true;
              "checkJs" = true;
              "allowJs" = true;
              "jsx" = "react-jsx";
              "jsxImportSource" = "${agsV2Packages.astal}/share/astal/gjs/src/jsx";
              "paths" = {
                "astal" = ["${agsV2Packages.astal}/share/astal/gjs"];
                "astal/*" = ["${agsV2Packages.astal}/share/astal/gjs/src/*"];
              };
            };
          };
        }
      );
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
