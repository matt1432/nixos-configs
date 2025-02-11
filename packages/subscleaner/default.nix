{
  lib,
  pkgs,
  poetry2nix,
  subscleaner-src,
  ...
}: let
  inherit (poetry2nix.lib.mkPoetry2Nix {inherit pkgs;}) mkPoetryApplication;
in
  mkPoetryApplication {
    projectDir = subscleaner-src;
    preferWheels = true;

    meta = {
      mainProgram = "subscleaner";
      license = lib.licenses.gpl3Only;
      homepage = "https://gitlab.com/rogs/subscleaner";
      description = ''
        Subscleaner is a Python script that removes advertisements from subtitle files.
        It's designed to help you enjoy your favorite shows and movies without the
        distraction of unwanted ads in the subtitles.
      '';
    };
  }
