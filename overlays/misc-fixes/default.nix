final: prev: {
  # FIXME: do some other stuff and make PR
  nix-update = prev.nix-update.overrideAttrs (o: {
    src = prev.fetchFromGitHub {
      owner = "matt1432";
      repo = "nix-update";
      rev = "21de1ebd7e7c22de03f0a9c7e1f6cd488fa96d03";
      hash = "sha256-ukapzy0+mS4rorX3D22lRKX/D9TXmkq8W2YNDQIq7A8=";
    };
  });

  # FIXME: https://pr-tracker.nelim.org/?pr=382559
  obs-studio-plugins =
    prev.obs-studio-plugins
    // {
      droidcam-obs = prev.obs-studio-plugins.droidcam-obs.overrideAttrs (o: rec {
        version = "2.3.4";
        src = prev.fetchFromGitHub {
          owner = "dev47apps";
          repo = "droidcam-obs-plugin";
          tag = version;
          sha256 = "sha256-KWMLhddK561xA+EjvoG4tXRW4xoLil31JcTTfppblmA=";
        };
        postPatch = "";
        makeFlags =
          o.makeFlags
          ++ [
            "LIBOBS_INCLUDES=${prev.obs-studio}/include/obs"
            "FFMPEG_INCLUDES=${prev.lib.getLib prev.ffmpeg}"
          ];
      });
    };
}
