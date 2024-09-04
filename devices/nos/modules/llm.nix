{self, ...}: let
  tailscaleIP = "100.64.0.4";
in {
  imports = [self.nixosModules.wyoming-plus];

  services = {
    # Speech-to-Text
    wyoming.faster-whisper.servers."en" = {
      enable = true;
      uri = "tcp://${tailscaleIP}:10300";

      # see https://github.com/rhasspy/wyoming-faster-whisper/releases/tag/v2.0.0
      model = "medium";
      language = "en";
      device = "cuda";
    };

    # Text-to-Intent
    ollama = {
      enable = true;
      acceleration = "cuda";

      host = tailscaleIP;
      port = 11434;

      loadModels = ["fixt/home-3b-v3"];
    };
  };
}
