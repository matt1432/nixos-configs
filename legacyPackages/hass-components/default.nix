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
        inherit smartinspect urllib3;
        python3Packages = spotPython3Packages;
      };

      urllib3 = spotPython3Packages.callPackage ./spotifyplus/urllib3.nix {};
    };
  };

  buildHassComponent = file: extraArgs:
    hass.callPackage file (inputs // extraArgs // {});
in {
  extended-ollama-conversation = buildHassComponent ./extended-ollama-conversation {
    openai = import ./extended-ollama-conversation/openai.nix pkgs;
  };
  spotifyplus = buildHassComponent ./spotifyplus {
    python3Packages = spotPython3Packages;
  };
})
