self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.neovim;

  searxCfg =
    self.nixosConfigurations.nos.config.services.searx.settings.server or {
      bind_address = "127.0.0.1";
      port = 8080;
    };
  inherit (searxCfg) bind_address port;

  strataEndpoint = "http://${bind_address}:9292/v1";
  strataKey =
    self.nixosConfigurations.nos.config.virtualisation.docker.compose.strata.services.strata.environment.API_KEY or "none";
in {
  config = mkIf (cfg.enable && cfg.ideConfig.llmProvider != "none") {
    home.packages = [pkgs.pi-coding-agent];

    home.file.".pi/agent/models.json".text = builtins.toJSON {
      providers.strata = {
        baseUrl = strataEndpoint;
        api = "openai-completions";
        apiKey = strataKey;
        models = [
          {
            id = "qwen3.8-flash-next-gyro-s";
            name = "Qwen3.8 Flash Next (Gyro-S)";
            reasoning = true;
            input = ["text" "image"];
            contextWindow = 262144;
            maxTokens = 32768;
            # Strata takes reasoning_effort, like the post's pi setup
            compat.thinkingFormat = "openai";
          }
        ];
      };
    };

    # Adds web_search and web_fetch tools to pi
    home.file.".pi/agent/extensions/rpiv-web-tools".source = "${pkgs.scopedPackages.piExtensions.rpiv-web-tools}/node_modules/@juicesharp/rpiv-web-tools";

    xdg.configFile."rpiv-web-tools/config.json".text = builtins.toJSON {
      provider = "searxng";
      baseUrls.searxng = "http://${bind_address}:${toString port}";
      interceptors.github = true;
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
