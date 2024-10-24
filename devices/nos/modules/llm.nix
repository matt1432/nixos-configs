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
      # FIXME: https://pr-tracker.nelim.org/?pr=350083
      package =
        (pkgs.wyoming-faster-whisper.override {
          python3Packages =
            (pkgs.python3.override {
              packageOverrides = pyfinal: pyprev: {
                faster-whisper = pyprev.faster-whisper.overridePythonAttrs {
                  version = "unstable-2024-07-26";
                  src = pkgs.fetchFromGitHub {
                    owner = "SYSTRAN";
                    repo = "faster-whisper";
                    rev = "d57c5b40b06e59ec44240d93485a95799548af50";
                    hash = "sha256-C/O+wt3dykQJmH+VsVkpQwEAdyW8goMUMKR0Z3Y7jdo=";
                  };
                  pythonRelaxDeps = [
                    "tokenizers"
                    "av"
                  ];
                };
              };
            })
            .pkgs;
        })
        .overridePythonAttrs rec {
          version = "2.2.0";
          src = pkgs.fetchFromGitHub {
            owner = "rhasspy";
            repo = "wyoming-faster-whisper";
            rev = "refs/tags/v${version}";
            hash = "sha256-G46ycjpRu4MD00FiBM1H0DrPpXaaPlZ8yeoyZ7WYD48=";
          };
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
