{
  pkgs,
  self,
  ...
}: let
  tailscaleIP = "100.64.0.4";
in {
  imports = [self.nixosModules.wyoming-plus];

  # In case tailscale is down
  boot.kernel.sysctl."net.ipv4.ip_nonlocal_bind" = 1;

  services = {
    # Speech-to-Text
    wyoming.faster-whisper = {
      # FIXME: wyoming-faster-whisper requires av < 13.0.0. make issue in nixpkgs?
      package = pkgs.wyoming-faster-whisper.override {
        python3Packages =
          (pkgs.python3.override {
            packageOverrides = pyfinal: pyprev: {
              av =
                (pyprev.av.override {
                  ffmpeg-headless = pkgs.ffmpeg_6-headless;
                })
                .overridePythonAttrs (o: rec {
                  version = "12.3.0";
                  src = pkgs.fetchFromGitHub {
                    owner = "PyAV-Org";
                    repo = "PyAV";
                    rev = "refs/tags/v${version}";
                    hash = "sha256-ezeYv55UzNnnYDjrMz5YS5g2pV6U/Fxx3e2bCoPP3eI=";
                  };
                });
            };
          })
          .pkgs;
      };

      servers."en" = {
        enable = true;
        uri = "tcp://${tailscaleIP}:10300";

        # see https://github.com/rhasspy/wyoming-faster-whisper/releases/tag/v2.0.0
        model = "medium";
        language = "en";
        device = "cuda";
      };
    };

    # Text-to-Intent
    ollama = {
      enable = true;
      acceleration = "cuda";

      host = tailscaleIP;
      port = 11434;

      loadModels = ["mistral-nemo"];
      environmentVariables.OLLAMA_DEBUG = "1";
    };
  };
}
