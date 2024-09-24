self: {pkgs, ...}: {
  config = let
    inherit (self.inputs) agsV2;

    agsV2Packages = agsV2.packages.${pkgs.system};
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

      file = {
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
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
