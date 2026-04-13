{
  mainUser,
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
    wyoming.faster-whisper.servers."en" = {
      # TODO: re-enable this when homie is back up
      enable = false;
      uri = "tcp://${tailscaleIP}:10300";

      # see https://github.com/rhasspy/wyoming-faster-whisper/releases/tag/v2.0.0
      model = "medium";
      language = "en";
      device = "cuda";
    };

    # Text-to-Intent
    ollama = {
      # TODO: re-enable this when homie is back up
      enable = false;
      package = pkgs.ollama-cuda;

      host = tailscaleIP;
      port = 11434;

      loadModels = ["mistral-nemo"];
      environmentVariables.OLLAMA_DEBUG = "1";
    };
  };

  # https://github.com/rwade628/dot.nix/blob/b39596f26d615e9bf493989c599590f3092d8ab0/modules/nixos/services/ai.nix
  environment.etc."llama-templates/openai-gpt-oss-20b.jinja".source = pkgs.fetchurl {
    url = "https://huggingface.co/unsloth/gpt-oss-20b-GGUF/resolve/main/template";
    sha256 = "sha256-UUaKD9kBuoWITv/AV6Nh9t0z5LPJnq1F8mc9L9eaiUM=";
  };

  environment.etc."llama-swap/config.yaml".text = builtins.toJSON {
    models = {
      "Qwen3.5-35B-A3B-GGUF".cmd = ''
          ${pkgs.llama-cpp}/bin/llama-server
          -hf unsloth/Qwen3.5-35B-A3B-GGUF:UD-Q4_K_XL
          --port ''${PORT}
          --ctx-size 100000
          --n-predict 32768
          --temp 0.6
          --top-p 0.95
          --top-k 20
          --min-p 0.00
          --presence-penalty 0.0
          --repeat-penalty 1.0
          --jinja
        '';
    };

    groups = {
      embedding = {
        persistent = true;
        swap = false;
        exclusive = false;
        members = ["embeddinggemma:300m"];
      };
    };

    healthCheckTimeout = 28800;
    ttl = 3600;
  };

  systemd.services.llama-swap = {
    description = "llama-swap - OpenAI compatible proxy with automatic model swapping";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "simple";
      User = mainUser;
      Group = "users";
      ExecStart = "${pkgs.llama-swap}/bin/llama-swap --config /etc/llama-swap/config.yaml --listen ${tailscaleIP}:9292 --watch-config";
      Restart = "always";
      RestartSec = 10;

      # Environment for CUDA support
      Environment = [
        "PATH=/run/current-system/sw/bin"
        "LD_LIBRARY_PATH=/run/opengl-driver/lib:/run/opengl-driver-32/lib"
      ];

      # Environment needs access to cache directories for model downloads
      # Simplified security settings to avoid namespace issues
      PrivateTmp = true;
      NoNewPrivileges = true;
    };
  };
}
