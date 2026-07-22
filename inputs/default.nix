let
  inherit (import ./lib.nix) mkInput mkHyprDep mkSrc;
  inherit (builtins) listToAttrs;

  # Inputs
  mainInputs = {
    systems = mkInput {
      owner = "nix-systems";
      repo = "x86_64-linux";
    };

    nixpkgs = mkInput {
      type = "git";
      url = "https://github.com/NixOS/nixpkgs";
      ref = "nixos-unstable";
      shallow = true;
    };

    determinate-nix = mkInput {
      owner = "DeterminateSystems";
      repo = "nix-src";
    };

    home-manager = mkInput {
      owner = "nix-community";
      repo = "home-manager";
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
    nix-index-db = mkInput {
      owner = "Mic92";
      repo = "nix-index-database";
    };

    nix-output-monitor = mkInput {
      owner = "maralorn";
      repo = "nix-output-monitor";
    };

    nix-eval-jobs = mkInput {
      owner = "DeterminateSystems";
      repo = "nix-eval-jobs";
      inputs.nix.follows = "determinate-nix";
    };

    # These are here to make sure all 'systems' and popular inputs are the same
    flake-compat = mkInput {
      owner = "edolstra";
      repo = "flake-compat";
    };

    flake-parts = mkInput {
      owner = "hercules-ci";
      repo = "flake-parts";
    };

    flake-utils = mkInput {
      owner = "numtide";
      repo = "flake-utils";
    };

    gitignore = mkInput {
      owner = "hercules-ci";
      repo = "gitignore.nix";
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
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
    };

    treefmt-nix = mkInput {
      owner = "numtide";
      repo = "treefmt-nix";
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

    # NOTE: https://github.com/venkyr77/jellarr/pull/75
    jellarr = mkInput {
      # owner = "venkyr77";
      repo = "jellarr";
      # ref = "v0.1.1";

      owner = "matt1432";
      ref = "nix-pnpm-10";
    };

    letterboxdpy-src = mkInput {
      owner = "matt1432";
      repo = "letterboxdpy";
      flake = false;
    };

    jellyfin-auto-collections = mkInput {
      owner = "matt1432";
      repo = "Jellyfin-Auto-Collections";

      inputs.letterboxdpy-src.follows = "letterboxdpy-src";
    };

    bazarr-bulk = mkInput {
      owner = "mateoradman";
      repo = "bazarr-bulk";
    };

    kapowarr-react = mkInput {
      owner = "matt1432";
      repo = "KapowarrReact";
    };
  };

  desktopInputs = {
    hyprlandInputs = {
      hyprland = mkInput {
        owner = "hyprwm";
        repo = "Hyprland";
      };

      hyprexpo-src = mkInput {
        owner = "sandwichfarm";
        repo = "hyprexpo";

        flake = false;
      };

      hyprgrass = mkHyprDep {
        type = "git";
        url = "https://github.com/horriblename/hyprgrass";
        shallow = true;
        submodules = true;
      };

      touchpos = mkHyprDep {
        owner = "matt1432";
        repo = "touchpos";
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
      astal = mkInput {
        owner = "Aylur";
        repo = "astal";
      };

      ags = mkInput {
        owner = "Aylur";
        repo = "ags";
        inputs.astal.follows = "astal";
      };

      virtualkeyboard-adapter = mkInput {
        owner = "horriblename";
        repo = "fcitx-virtualkeyboard-adapter";
      };
    };
  };

  srcs = [
    {
      name = "my-images-src";
      type = "git";
      url = "https://git.nelim.org/matt1432/pub-images.git";
    }

    # Nvim plugins
    {
      name = "vimplugin-easytables-src";
      owner = "Myzel394";
      repo = "easytables.nvim";
    }
    {
      name = "vimplugin-roslyn-src";
      owner = "seblj";
      repo = "roslyn.nvim";
    }
    {
      name = "vimplugin-nix-develop-src";
      owner = "matt1432";
      repo = "nix-develop.nvim";
    }
    {
      name = "vimplugin-gitsigns-src";
      owner = "lewis6991";
      repo = "gitsigns.nvim";
    }
    {
      name = "vimplugin-otter-src";
      owner = "matt1432";
      repo = "otter.nvim";
      ref = "interpolation";
    }

    # Overlays & packages
    {
      owner = "ljcp";
      repo = "alive-server";
    }
    {
      name = "komf-src";
      # owner = "Snd-R";
      repo = "komf";

      # NOTE: https://github.com/Snd-R/komf/pull/259
      owner = "matt1432";
      ref = "personal";
    }
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
  // desktopInputs.hyprlandInputs
  // desktopInputs.shellInputs
  // (listToAttrs (map (x: {
      name = x.name or "${x.repo}-src";
      value = mkSrc (removeAttrs x ["name"]);
    })
    srcs))
