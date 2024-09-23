{pkgs, ...} @ inputs:
pkgs.lib.makeScope pkgs.newScope (hass: let
  spotPython3Packages = pkgs.python3Packages.override {
    overrides = self: super: rec {
      smartinspect = pkgs.callPackage ./spotifyplus/smartinspect.nix {
        inherit (inputs) smartinspect-src;
        python3Packages = spotPython3Packages;
      };

      spotifywebapi = pkgs.callPackage ./spotifyplus/spotifywebapi.nix {
        inherit (inputs) spotifywebapi-src;
        inherit smartinspect;
        python3Packages = spotPython3Packages;
      };
    };
  };

  buildHassComponent = file: extraArgs:
    hass.callPackage file (inputs // extraArgs // {});
in {
  extended-ollama-conversation = buildHassComponent ./extended-ollama-conversation {};
  spotifyplus = buildHassComponent ./spotifyplus {python3Packages = spotPython3Packages;};
})
