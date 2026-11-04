{pkgs, ...}: let
  tailscaleIP = "100.64.0.4";
  rwPath = "/var/lib/strata";
in {
  # For web_search tool
  imports = [(import ./searxng tailscaleIP)];

  # In case tailscale is down
  boot.kernel.sysctl."net.ipv4.ip_nonlocal_bind" = 1;

  hardware.nvidia-container-toolkit.enable = true;

  virtualisation.docker.compose."strata" = {
    services."strata" = {
      image = pkgs.callPackage ./images/strata.nix pkgs;
      restart = "always";

      ports = ["${tailscaleIP}:9292:8080"];
      devices = ["nvidia.com/gpu=all"];

      volumes = [
        # The pack, the MTP draft layer, presets and logs
        "${rwPath}/data:/data"
        # The 58.5 GB GGUF, downloaded by hand so it is not fetched again with every new volume
        "${rwPath}/models:/models:ro"
      ];

      environment = {
        FAMILY = "gyro";
        MODEL = "Gyro-S";
        MODEL_PATH = "/models/Qwen3.8-Flash-Next-Gyro-S-TQ1_0.gguf";

        # Strata does not serve beyond the container's loopback without a key. Port 9292 is only
        # on the tailnet, so this is a formality and not a secret.
        API_KEY = "6d3ee1c79f8692d62e5b0a1322fa22bedbc333551ecfbdf3";

        # Based on the "Agentic" config from
        # https://www.reddit.com/r/LocalLLaMA/comments/1xft2ae (RTX 5060 8 GiB + 32 GiB RAM),
        # adapted to an RTX 3060 12 GiB + 46 GiB RAM / 6 cores
        CONTEXT = "256k";
        KV = "q4_0";
        # parked sessions (the conversation cache below) instead of parallel slots, which OOM at >= 131K
        PARALLEL = "1";
        # in its own process: ~1-2 s per image, saves VRAM
        VISION = "cpu";
        TUNE = "skip";

        # Measured on this machine (bench of 8K/32K prompts, 400-token code answers, 35K-context answers):
        #   pcie-frac 1.0: all VRAM expert misses computed on the GPU. This 6-core CPU is the
        #                  bottleneck: 36 t/s vs 27 t/s at 0.6-0.8
        #   MTP draft layer (setup's default) + spec 6: 46 t/s vs 36 t/s without
        #   kv-resident 20480: the minimum, the VRAM is worth more as expert cache (37-45 t/s at 35K context)
        #   vram-reserve-mib 600: no display on this card. At 500 the engine warned of only 470 MiB free
        #                         at a request start (under 512 the driver can page VRAM to RAM)
        #   STRATA_RESIDENT_HEADROOM_GIB 8: RAM left for the rest of nos (6 left it critically low with MTP)
        STRATA_SET = toString [
          "pcie-frac=1.0"
          "spec=6"
          "spec-min-p=0.70"
          "kv-resident=20480"
          "vram-reserve-mib=600"
          "conversation-cache-mib=4096"
          "conversation-cache-slots=2"
          "conversation-cache-min-tokens=8000"
          "conversation-cache-min-free-mib=1024"
          "STRATA_RESIDENT_HEADROOM_GIB=8"
          "STRATA_PREFILL_CPU_SHARE=0"
        ];
      };

      # the engine page-locks ~22 GiB of experts
      ulimits.memlock = {
        soft = -1;
        hard = -1;
      };
      shm_size = "2gb";
      # the model drains and unloads on docker stop
      stop_grace_period = "2m";
    };
  };

  # Stopping the unit blocks until docker's stop_grace_period (2m) runs out. systemd's default
  # 90 s stop timeout would SIGKILL it before the model finishes unloading, so keep this above it.
  systemd.services.compose-strata.serviceConfig.TimeoutStopSec = "3min";

  # Unload the model after 10 min idle to free its RAM and VRAM (reloading takes ~50 s).
  systemd.paths.strata-idle-unload = {
    wantedBy = ["multi-user.target"];
    pathConfig = {
      PathChanged = "${rwPath}/data/install";
      MakeDirectory = true;
    };
  };

  systemd.services.strata-idle-unload = {
    wantedBy = ["multi-user.target" "compose-strata.service"];
    before = ["compose-strata.service"];

    path = [pkgs.coreutils pkgs.jq pkgs.systemd];
    serviceConfig.Type = "oneshot";
    script = ''
      patched=""
      for cfg in ${rwPath}/data/install/strata-*.json; do
        [ -f "$cfg" ] || continue
        # already set: no write, which would trigger this again
        jq -e '.idle_unload_s == 600' "$cfg" > /dev/null && continue
        jq '.idle_unload_s = 600' "$cfg" > "$cfg.tmp"
        mv "$cfg.tmp" "$cfg"
        patched=1
      done

      # not active when this runs before a start: nothing to restart then
      if [ -n "$patched" ] && systemctl is-active -q compose-strata.service; then
        echo "idle_unload_s set: restarting the container so the server reads it"
        systemctl try-restart --no-block compose-strata.service
      fi
    '';
  };
}
