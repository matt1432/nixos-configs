let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  lib = import "${builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${lock.nodes.nixpkgs.locked.rev}.tar.gz";
    sha256 = lock.nodes.nixpkgs.locked.narHash;
  }}/lib";

  inherit (lib) attrValues findFirst foldl' hasAttr listToAttrs matchAttrs map optionalAttrs recursiveUpdate removeAttrs;

  recursiveUpdateList = list: foldl' recursiveUpdate {} list;

  # Misc functions
  mkInput = {type ? "github", ...} @ info: let
    input =
      findFirst
      (x: matchAttrs (removeAttrs info ["inputs"]) (x.original or {})) {}
      (attrValues lock.nodes);

    mkOverride = i:
      optionalAttrs
      (hasAttr i (input.inputs or {}))
      {inputs.${i}.follows = i;};
  in
    recursiveUpdateList [
      info
      {inherit type;}
      (mkOverride "systems")
      (mkOverride "flake-utils")
      (mkOverride "lib-aggregate")
    ];

  mkDep = info: mkInput (recursiveUpdate info {inputs.nixpkgs.follows = "nixpkgs";});
  mkHyprDep = info: mkInput (recursiveUpdate info {inputs.hyprland.follows = "hyprland";});
  mkSrc = info: mkInput (info // {flake = false;});

  # Inputs
  nixTools = {
    nix-fast-build = mkDep {
      owner = "Mic92";
      repo = "nix-fast-build";
    };

    nurl = mkDep {
      owner = "matt1432";
      repo = "nurl";
    };

    nix-index-db = mkDep {
      owner = "Mic92";
      repo = "nix-index-database";
    };

    nh = mkDep {
      owner = "viperML";
      repo = "nh";
    };

    nix-melt = mkDep {
      owner = "nix-community";
      repo = "nix-melt";
    };

    # These are here to make sure all 'systems' are the same
    flake-utils = mkInput {
      owner = "numtide";
      repo = "flake-utils";
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

    headscale = mkDep {
      owner = "juanfont";
      repo = "headscale";
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
        type = "git";
        url = "https://github.com/hyprwm/Hyprland";
        submodules = true;
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

      astal-tray = mkDep {
        owner = "astal-sh";
        repo = "tray";
      };

      gtk-session-lock = mkDep {
        owner = "Cu3PO42";
        repo = "gtk-session-lock";
      };
    };
  };

  srcs = [
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
      ref = "v.9.4";
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
