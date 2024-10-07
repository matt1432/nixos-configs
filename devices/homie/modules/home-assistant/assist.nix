{
  pkgs,
  self,
  wakewords-src,
  ...
}: {
  imports = [
    self.nixosModules.esphome-plus
    self.nixosModules.wyoming-plus
  ];

  services = {
    home-assistant = {
      package =
        (pkgs.home-assistant.override {
          packageOverrides = final: prev: {
            # Needed for spotifyplus
            inherit (self.packages.${pkgs.system}) urllib3;

            # Version before HassStartTimer
            home-assistant-intents = final.buildPythonPackage rec {
              pname = "home-assistant-intents";
              version = "2024.4.3";
              format = "wheel";
              disabled = final.pythonOlder "3.9";
              src = final.fetchPypi {
                inherit version format;
                pname = "home_assistant_intents";
                dist = "py3";
                python = "py3";
                hash = "sha256-GraYVtioKIoKlPRBhhhzlbBfI6heXAaA1MQpUqAgEDQ=";
              };
              build-system = [
                final.setuptools
              ];
              doCheck = false;
              pytestFlagsArray = [
                "intents/tests"
              ];
            };
          };
        })
        .overrideAttrs {
          disabledTestPaths = [
            # we neither run nor distribute hassfest
            "tests/hassfest"
            # we don't care about code quality
            "tests/pylint"
            # redundant component import test, which would make debugpy & sentry expensive to review
            "tests/test_circular_imports.py"
            # don't bulk test all components
            "tests/components"

            # Make old intent version build
            "tests/scripts/test_check_config.py"
            "tests/test_bootstrap.py"
            "tests/helpers"
          ];
        };

      customComponents = builtins.attrValues {
        inherit
          (self.legacyPackages.${pkgs.system}.hass-components)
          extended-ollama-conversation
          ha-fallback-conversation
          tuya-local
          ;
      };

      extraComponents = [
        "esphome"
        "ollama"
        "wyoming"
        "scrape"
      ];

      config = {
        assist_pipeline = {};
        conversation = {};
        media_source = {};
      };
    };

    wyoming = {
      piper.servers."en" = {
        enable = true;
        uri = "tcp://127.0.0.1:10200";

        # see https://github.com/rhasspy/rhasspy3/blob/master/programs/tts/piper/script/download.py
        voice = "en-us-ryan-low"; # using `hfc male (medium)` in GUI
        speaker = 0;
      };

      openwakeword = {
        enable = true;
        uri = "tcp://127.0.0.1:10400";

        customModelsDirectories = ["${wakewords-src}/en/yo_homie"];
      };
    };

    esphome = {
      enable = true;
      address = "100.64.0.10";
      port = 6052;
    };
  };

  # In case tailscale is down
  boot.kernel.sysctl."net.ipv4.ip_nonlocal_bind" = 1;
}
