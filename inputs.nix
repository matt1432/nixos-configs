let
  inherit (import ./lib {}) mkDep mkInput mkHyprDep mkSrc;
  inherit (builtins) listToAttrs map removeAttrs;

  # Inputs
  nixTools = {
    nix-fast-build = mkDep {
      owner = "Mic92";
      repo = "nix-fast-build";
    };

    nix-index-db = mkDep {
      owner = "Mic92";
      repo = "nix-index-database";
    };

    nh = mkDep {
      owner = "viperML";
      repo = "nh";
    };

    # These are here to make sure all 'systems' are the same
    flake-utils = mkInput {
      owner = "numtide";
      repo = "flake-utils";
    };
    flake-parts = mkInput {
      owner = "hercules-ci";
      repo = "flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = mkDep {
      owner = "numtide";
      repo = "treefmt-nix";
    };
    lib-aggregate = mkInput {
      owner = "nix-community";
      repo = "lib-aggregate";
    };
  };

  overlays = {
    nixpkgs-wayland = mkDep {
      owner = "nix-community";
      repo = "nixpkgs-wayland";
    };

    nix-gaming = mkDep {
      owner = "fufexan";
      repo = "nix-gaming";
    };
  };

  nvimInputs = {
    # uses nixVersions.nix_2_19
    nixd = mkDep {
      owner = "nix-community";
      repo = "nixd";
    };
  };

  clusterInputs = {
    pcsd = mkDep {
      owner = "matt1432";
      repo = "nixos-pcsd";
    };

    # FIXME: use nixpkgs once this reaches unstable https://pr-tracker.nelim.org/?pr=340054
    headscale = mkDep {
      owner = "juanfont";
      repo = "headscale";
      ref = "v0.23.0";
    };

    caddy-plugins = mkDep {
      owner = "matt1432";
      repo = "nixos-caddy-cloudflare";
    };
  };

  serviviInputs = {
    minix = mkDep {
      owner = "matt1432";
      repo = "Minix";
    };

    pr-tracker = mkDep {
      owner = "matt1432";
      repo = "pr-tracker";
    };
  };

  nosInputs = {
    khepri = mkDep {
      owner = "matt1432";
      repo = "khepri";
    };

    jellyfin-flake = mkDep {
      owner = "matt1432";
      repo = "nixos-jellyfin";
    };

    bazarr-bulk = mkDep {
      owner = "mateoradman";
      repo = "bazarr-bulk";
    };

    subsync = mkDep {
      owner = "matt1432";
      repo = "subsync";

      # Keep version that uses Sphinxbase
      rev = "ee9e1592ae4ec7c694d8857aa72be079d81ea209";
    };
  };

  desktopInputs = {
    hyprlandInputs = {
      hyprland = mkDep {
        owner = "hyprwm";
        repo = "Hyprland";
      };

      hyprland-plugins = mkHyprDep {
        owner = "hyprwm";
        repo = "hyprland-plugins";

        # type = "path";
        # path = "/home/matt/git/hyprland-plugins";
      };

      hyprgrass = mkHyprDep {
        owner = "horriblename";
        repo = "hyprgrass";
      };

      hyprpaper = mkDep {
        owner = "hyprwm";
        repo = "hyprpaper";

        inputs = {
          hyprlang.follows = "hyprland/hyprlang";
          hyprutils.follows = "hyprland/hyprutils";
          hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
          nixpkgs.follows = "hyprland/nixpkgs";
          systems.follows = "hyprland/systems";
        };
      };

      grim-hyprland = mkDep {
        owner = "eriedaberrie";
        repo = "grim-hyprland";
      };

      discord-overlay = mkDep {
        owner = "matt1432";
        repo = "discord-nightly-overlay";
      };
    };

    agsInputs = {
      ags = mkDep {
        owner = "Aylur";
        repo = "ags";
      };

      agsV2 = mkDep {
        owner = "Aylur";
        repo = "ags";
        ref = "v2";

        inputs.astal.follows = "astal";
      };

      astal = mkDep {
        owner = "Aylur";
        repo = "astal";
      };

      gtk-session-lock = mkDep {
        owner = "Cu3PO42";
        repo = "gtk-session-lock";
      };
    };
  };

  srcs = [
    # Home-assistant
    {
      name = "extended-ollama-conversation-src";
      owner = "TheNimaj";
      repo = "extended_ollama_conversation";
    }
    {
      owner = "make-all";
      repo = "tuya-local";
    }
    {
      name = "netdaemon-src";
      owner = "net-daemon";
      repo = "integration";
    }
    {
      name = "spotifyplus-src";
      owner = "thlucas1";
      repo = "homeassistantcomponent_spotifyplus";
    }
    {
      name = "smartinspect-src";
      owner = "thlucas1";
      repo = "SmartInspectPython";
    }
    {
      name = "spotifywebapi-src";
      owner = "thlucas1";
      repo = "SpotifyWebApiPython";
    }

    {
      name = "wakewords-src";
      owner = "fwartner";
      repo = "home-assistant-wakewords-collection";
    }
    {
      owner = "berti24";
      repo = "dracul-ha";
    }

    # Nvim plugins
    {
      name = "vimplugin-easytables-src";
      owner = "Myzel394";
      repo = "easytables.nvim";
    }
    {
      name = "vimplugin-ts-error-translator-src";
      owner = "dmmulroy";
      repo = "ts-error-translator.nvim";
    }

    # Overlays & packages
    {
      owner = "rushsteve1";
      repo = "trash-d";
    }
    {
      type = "gitlab";
      owner = "mishakmak";
      repo = "pam-fprint-grosshack";
    }
    {
      type = "gitlab";
      owner = "phoneybadger";
      repo = "pokemon-colorscripts";
    }
    {
      name = "gpu-screen-recorder-src";
      type = "git";
      url = "https://repo.dec05eba.com/gpu-screen-recorder";
    }
    {
      owner = "libratbag";
      repo = "libratbag";
    }
    {
      owner = "libratbag";
      repo = "piper";
    }
    {
      owner = "gjsify";
      repo = "ts-for-gir";
    }
    {
      owner = "jcnils";
      repo = "protonhax";
    }

    # MPV scripts
    {
      name = "modernx-src";
      owner = "cyl0";
      repo = "ModernX";
    }
    {
      owner = "d87";
      repo = "mpv-persist-properties";
    }
    {
      owner = "christoph-heinrich";
      repo = "mpv-pointer-event";
    }
    {
      owner = "christoph-heinrich";
      repo = "mpv-touch-gestures";
    }
    {
      name = "eisa-scripts-src";
      owner = "Eisa01";
      repo = "mpv-scripts";
    }

    ## Theme sources
    {
      name = "bat-theme-src";
      owner = "matt1432";
      repo = "bat";
    }
    {
      owner = "Godiesc";
      repo = "firefox-gx";
      ref = "v.9.5";
    }
    {
      name = "git-theme-src";
      owner = "dracula";
      repo = "git";
    }
    {
      name = "gtk-theme-src";
      owner = "dracula";
      repo = "gtk";
    }
    {
      name = "nvim-theme-src";
      owner = "Mofiqul";
      repo = "dracula.nvim";
    }
    {
      owner = "matt1432";
      repo = "dracula-plymouth";
    }
    {
      name = "sioyek-theme-src";
      owner = "dracula";
      repo = "sioyek";
    }
  ];
in {
  inherit mkDep mkInput mkSrc;

  otherInputs =
    {
      flakegen = {
        url = "github:jorsn/flakegen";
        inputs.systems.follows = "systems";
      };
    }
    // nixTools
    // overlays
    // nvimInputs
    // clusterInputs
    // serviviInputs
    // nosInputs
    // desktopInputs.hyprlandInputs
    // desktopInputs.agsInputs
    // (listToAttrs (map (x: {
        name = x.name or "${x.repo}-src";
        value = mkSrc (removeAttrs x ["name"]);
      })
      srcs));
}
