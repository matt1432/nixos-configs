# TODO: add README
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
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
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
    nix-fast-build = mkInput {
      owner = "Mic92";
      repo = "nix-fast-build";
    };

    nix-eval-jobs = mkInput {
      owner = "nix-community";
      repo = "nix-eval-jobs";
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

    poetry2nix = mkInput {
      owner = "nix-community";
      repo = "poetry2nix";
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
    nixpkgs-wayland = mkInput {
      owner = "nix-community";
      repo = "nixpkgs-wayland";
    };

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
    khepri = mkInput {
      owner = "matt1432";
      repo = "khepri";
    };

    jellyfin-flake = mkInput {
      owner = "matt1432";
      repo = "nixos-jellyfin";
    };

    bazarr-bulk = mkInput {
      owner = "mateoradman";
      repo = "bazarr-bulk";
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

        # FIXME: https://github.com/horriblename/hyprgrass/pull/207
        rev = "184467d3b785c67062b240bd0eb5239e7ec5d09e";
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

    agsInputs = {
      astal = mkInput {
        owner = "Aylur";
        repo = "astal";
      };

      ags = mkInput {
        owner = "Aylur";
        repo = "ags";

        inputs.astal.follows = "astal";
      };

      kompass = mkInput {
        owner = "kotontrion";
        repo = "kompass";

        inputs.astal.follows = "astal";
      };

      gtk-session-lock = mkInput {
        owner = "Cu3PO42";
        repo = "gtk-session-lock";
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
      owner = "m50";
      repo = "ha-fallback-conversation";
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
    {
      owner = "Nerwyn";
      repo = "material-rounded-theme";
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
      owner = "rushsteve1";
      repo = "trash-d";
    }
    {
      type = "gitlab";
      owner = "rogs";
      repo = "subscleaner";
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
      # ref = "v.9.9";
      rev = "6f5d07e11e008d6cbf4461e53daf80820afa8418";
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
  // desktopInputs.agsInputs
  // (listToAttrs (map (x: {
      name = x.name or "${x.repo}-src";
      value = mkSrc (removeAttrs x ["name"]);
    })
    srcs))
