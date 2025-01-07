{
  buildHassComponent,
  pkgs,
  ...
}: let
  python3Packages = pkgs.python3Packages.override {
    overrides = final: prev: {
      tinytuya = prev.tinytuya.overrideAttrs (o: rec {
        version = "1.16.0";
        src = pkgs.fetchFromGitHub {
          owner = "jasonacox";
          repo = "tinytuya";
          rev = "v${version}";
          hash = "sha256-K65kZjLa5AJG9FEYAs/Jf2UC8qiP7BkC8znHMHMYeg4=";
        };
      });
    };
  };
in
  buildHassComponent ./tinytuya.nix {inherit python3Packages;}
