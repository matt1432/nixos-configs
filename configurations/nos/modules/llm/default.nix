{
  mainUser,
  pkgs,
  ...
}: let
  tailscaleIP = "100.64.0.4";
in {
  # In case tailscale is down
  boot.kernel.sysctl."net.ipv4.ip_nonlocal_bind" = 1;

  environment.etc."llama-swap/config.yaml".text = builtins.toJSON {
    # llama-swap hands each model a backend port counting up from 5800 and does not
    # check whether that port is actually free
    startPort = 8081;

    models = {
      # Qwen3.6-35B-A3B (MoE, 3B active) on RTX 3060 12GiB + 46GiB RAM / 6 cores.
      #
      #   KV @ Q8_0 = 10 layers * 2 (K,V) * 2 kv_heads * 256 head_dim * 1B
      #             = 10 KiB/token -> 2.5 GiB at the full 256K context.
      # That is why KV Q8_0 + 256K fits comfortably.
      #
      # Weights (Q4_K_M) are 22.1 GB and do NOT fit in 12 GiB of VRAM, so:
      #   -ngl 40          offload every non-expert tensor (attention, linear-attn,
      #                    embeddings) so all 256K of KV lands in VRAM, and
      #   --n-cpu-moe 32   pin the first 32 layers' experts to CPU, leaving the
      #                    last 8 expert layers (~3.6 GB) on the GPU.
      # Measured on this machine (54K-token prompt):
      #   --n-cpu-moe 26 -> CRASH: cudaMalloc failed: out of memory
      #   --n-cpu-moe 28 -> 561 MiB VRAM free, 19.2 tok/s
      #   --n-cpu-moe 30 -> 1739 MiB free, 23.1 tok/s
      #   --n-cpu-moe 32 -> 2667 MiB free, 22.7 tok/s   <- chosen, same speed, 5x headroom
      #   --n-cpu-moe 34 -> 3597 MiB free, 21.4 tok/s
      # Never drop --n-cpu-moe below 30: the extra VRAM is not worth an OOM crash.
      #
      # Verified end to end at --ctx-size 262144 (VRAM is preallocated, so it stays
      # flat no matter how much context is actually used):
      #   54K ctx -> 486 t/s prompt, 22.7 t/s gen | 9653 MiB VRAM, 2667 free
      #  180K ctx -> 431 t/s prompt, 15.1 t/s gen | 9653 MiB VRAM, 2667 free
      #  252K ctx -> 401 t/s prompt, 10.2 t/s gen | 9653 MiB VRAM, 2667 free
      "qwen3.6-35b-a3b".cmd = toString [
        "${pkgs.llama-cpp}/bin/llama-server"
        "-hf unsloth/Qwen3.6-35B-A3B-GGUF:UD-Q4_K_M"
        "--port \${PORT}"
        "--alias qwen3.6-35b-a3b"

        # text-only: skips the 861 MB vision projector, which otherwise OOMs the GPU
        "--no-mmproj"

        # --- context + KV cache: 256K @ Q8_0 ~= 2.5 GiB ---
        "--ctx-size 262144"
        "--cache-type-k q8_0"
        "--cache-type-v q8_0"
        "--flash-attn on"
        "--parallel 1"

        # --- GPU/CPU split for 22 GB of weights on a 12 GB card ---
        "-ngl 40"
        "--n-cpu-moe 32"

        # --- sampling: Qwen3.6 recommended, thinking mode, general tasks ---
        "--temp 1.0"
        "--top-p 0.95"
        "--top-k 20"
        "--min-p 0.0"
        "--presence-penalty 1.5"
        "--repeat-penalty 1.0"
        "--n-predict -1"

        "--jinja"
      ];
    };

    healthCheckTimeout = 28800;
    ttl = 600;
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
