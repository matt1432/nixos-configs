let
  inherit (import ./lib.nix) mkInput mkHyprDep mkSrc;
  inherit (builtins) listToAttrs map removeAttrs;

  # Inputs
  mainInputs = {
    systems = mkInput {
      owner = "nix-systems";
      repo = "default-linux";
    };

    nixpkgs = mkInput {
      type = "git";
      url = "https://github.com/NixOS/nixpkgs";
      ref = "nixos-unstable";
      shallow = true;
    };

    home-manager = mkInput {
      owner = "nix-community";
      repo = "home-manager";
    };

    nix-on-droid = mkInput {
      owner = "nix-community";
      repo = "nix-on-droid";

      inputs.home-manager.follows = "home-manager";
    };

    sops-nix = mkInput {
      owner = "Mic92";
      repo = "sops-nix";
    };

    secrets = mkInput {
      type = "git";
      url = "ssh://git@git.nelim.org/matt1432/nixos-secrets";

      inputs.sops-nix.follows = "sops-nix";
    };
  };

  nixTools = {
    nix-serve-ng = mkInput {
      owner = "aristanetworks";
      repo = "nix-serve-ng";

      inputs.utils.follows = "flake-utils";
    };

    nix-fast-build = mkInput {
      owner = "Mic92";
      repo = "nix-fast-build";
    };

    nix-eval-jobs = mkInput {
      owner = "nix-community";
      repo = "nix-eval-jobs";
      ref = "v2.28.1";
    };

    nix-index-db = mkInput {
      owner = "Mic92";
      repo = "nix-index-database";
    };

    nh = mkInput {
      owner = "viperML";
      repo = "nh";
    };

    nurl = mkInput {
      owner = "nix-community";
      repo = "nurl";
    };

    # These are here to make sure all 'systems' and popular inputs are the same
    flake-compat = mkInput {
      owner = "edolstra";
      repo = "flake-compat";
    };
    flake-utils = mkInput {
      owner = "numtide";
      repo = "flake-utils";
    };
    flake-parts = mkInput {
      owner = "hercules-ci";
      repo = "flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = mkInput {
      owner = "numtide";
      repo = "treefmt-nix";
    };
    lib-aggregate = mkInput {
      owner = "nix-community";
      repo = "lib-aggregate";
    };
    nix-github-actions = mkInput {
      owner = "nix-community";
      repo = "nix-github-actions";
    };
    pre-commit-hooks = mkInput {
      owner = "cachix";
      repo = "git-hooks.nix";
      inputs.flake-compat.follows = "flake-compat";
    };
  };

  overlays = {
    nix-gaming = mkInput {
      owner = "fufexan";
      repo = "nix-gaming";
    };
  };

  nvimInputs = {
    nixd = mkInput {
      owner = "nix-community";
      repo = "nixd";
    };
  };

  clusterInputs = {
    pcsd = mkInput {
      owner = "matt1432";
      repo = "nixos-pcsd";
    };
  };

  serviviInputs = {
    minix = mkInput {
      owner = "matt1432";
      repo = "Minix";
    };

    pr-tracker = mkInput {
      owner = "matt1432";
      repo = "pr-tracker";
    };
  };

  nosInputs = {
    docker-compose = mkInput {
      owner = "matt1432";
      repo = "nixos-docker-compose";
    };

    nixos-jellyfin = mkInput {
      owner = "matt1432";
      repo = "nixos-jellyfin";
    };

    bazarr-bulk = mkInput {
      owner = "mateoradman";
      repo = "bazarr-bulk";
    };

    kapowarr = mkInput {
      owner = "matt1432";
      repo = "Kapowarr";
      ref = "build-system";
      # type = "path";
      # path = "/home/matt/git/Kapowarr";
    };
  };

  desktopInputs = {
    hyprlandInputs = {
      hyprland = mkInput {
        owner = "hyprwm";
        repo = "Hyprland";
      };

      hyprland-plugins = mkHyprDep {
        owner = "hyprwm";
        repo = "hyprland-plugins";
      };

      hyprgrass = mkHyprDep {
        owner = "horriblename";
        repo = "hyprgrass";

        # FIXME: https://github.com/horriblename/hyprgrass/pull/234
        ref = "e2effc755ccac0450a554da6014755d1ae8bf5e1";
      };

      hyprpaper = mkHyprDep {
        owner = "hyprwm";
        repo = "hyprpaper";
      };

      grim-hyprland = mkInput {
        owner = "eriedaberrie";
        repo = "grim-hyprland";
      };

      nixcord = mkInput {
        owner = "kaylorben";
        repo = "nixcord";
      };
    };

    shellInputs = {
      quickshell = mkInput {
        type = "git";
        url = "https://git.outfoxxed.me/quickshell/quickshell";
      };

      astal = mkInput {
        # owner = "Aylur";
        repo = "astal";

        # FIXME: https://github.com/Aylur/astal/pull/314
        owner = "matt1432";
        ref = "overlay";
      };

      ags = mkInput {
        # owner = "Aylur";
        repo = "ags";

        # FIXME: https://github.com/Aylur/astal/pull/314
        owner = "matt1432";
        ref = "overlay";

        inputs.astal.follows = "astal";
      };

      kompass = mkInput {
        owner = "kotontrion";
        repo = "kompass";

        inputs.astal.follows = "astal";
      };

      virtualkeyboard-adapter = mkInput {
        owner = "horriblename";
        repo = "fcitx-virtualkeyboard-adapter";
      };
    };
  };

  bbsteamieInputs = {
    jovian = mkInput {
      owner = "Jovian-Experiments";
      repo = "Jovian-NixOS";
    };
  };

  srcs = [
    # Home-assistant
    ## Components
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
      owner = "osk2";
      repo = "yamaha-soundbar";
    }

    ### SpotifyPlus
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
    ###

    ## Voice
    {
      name = "wakewords-src";
      owner = "fwartner";
      repo = "home-assistant-wakewords-collection";
    }

    ## Themes
    {
      owner = "berti24";
      repo = "dracul-ha";
    }
    {
      name = "caule-themes-src";
      owner = "ricardoquecria";
      repo = "caule-themes-pack-1";
    }

    ## Lovelace Components
    {
      owner = "beecho01";
      repo = "material-symbols";
    }
    {
      owner = "elchininet";
      repo = "custom-sidebar";
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
    {
      name = "vimplugin-roslyn-nvim-src";
      owner = "seblj";
      repo = "roslyn.nvim";
    }
    {
      name = "nix-develop-nvim-src";
      owner = "matt1432";
      repo = "nix-develop.nvim";
    }

    # Overlays & packages
    {
      type = "gitlab";
      owner = "rogs";
      repo = "subscleaner";
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

    # MPV scripts
    {
      name = "modernz-src";
      owner = "Samillion";
      repo = "ModernZ";
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
in
  {
    flakegen = {
      url = "github:jorsn/flakegen";
      inputs.systems.follows = "systems";
    };
  }
  // mainInputs
  // nixTools
  // overlays
  // nvimInputs
  // clusterInputs
  // serviviInputs
  // nosInputs
  // bbsteamieInputs
  // desktopInputs.hyprlandInputs
  // desktopInputs.shellInputs
  // (listToAttrs (map (x: {
      name = x.name or "${x.repo}-src";
      value = mkSrc (removeAttrs x ["name"]);
    })
    srcs))
