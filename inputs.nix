let
  inherit (builtins) listToAttrs map removeAttrs;

  # Misc functions
  mkInput = {type ? "github", ...} @ info: info // {inherit type;};
  mkDep = info: (mkInput info) // {inputs.nixpkgs.follows = "nixpkgs";};
  mkHyprDep = info: (mkInput info) // {inputs.hyprland.follows = "hyprland";};
  mkSrc = info: (mkInput info) // {flake = false;};

  # Inputs
  nixTools = {
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

    mozilla-addons-to-nix = mkDep {
      type = "sourcehut";
      owner = "~rycee";
      repo = "mozilla-addons-to-nix";
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
    neovim-nightly = mkDep {
      owner = "nix-community";
      repo = "neovim-nightly-overlay";
    };

    stylelint-lsp = mkDep {
      owner = "matt1432";
      repo = "stylelint-lsp";
    };

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
    nms = mkDep {
      owner = "matt1432";
      repo = "nixos-minecraft-servers";
    };

    steam-servers = mkDep {
      owner = "matt1432";
      repo = "nix-steam-servers";
    };

    nix-eval-jobs = mkDep {
      owner = "nix-community";
      repo = "nix-eval-jobs";
    };

    nix-fast-build = mkDep {
      owner = "Mic92";
      repo = "nix-fast-build";
    };
  };

  nosInputs = {
    arion = mkDep {
      owner = "hercules-ci";
      repo = "arion";
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

      Hyprspace = mkHyprDep {
        owner = "KZDKM";
        repo = "Hyprspace";
      };

      hyprgrass = mkHyprDep {
        owner = "horriblename";
        repo = "hyprgrass";
      };

      grim-hyprland = mkDep {
        owner = "eriedaberrie";
        repo = "grim-hyprland";
      };

      wpaperd = mkDep {
        owner = "danyspin97";
        repo = "wpaperd";

        # FIXME: latest breaks
        rev = "d4a9cd8b751bed47bf57a93a7ee63054ba43e63b";
      };
    };

    agsInputs = {
      ags = mkDep {
        owner = "Aylur";
        repo = "ags";
      };

      astal = mkDep {
        owner = "Aylur";
        repo = "Astal";
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
      owner = "Malpiszonekx4";
      repo = "curseforge-server-downloader";
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
      name = "jellyfin-ultrachromic-src";
      owner = "CTalvio";
      repo = "Ultrachromic";
    }
    {
      name = "bat-theme-src";
      owner = "matt1432";
      repo = "bat";
    }
    {
      owner = "Godiesc";
      repo = "firefox-gx";
      ref = "v.9.2";
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
    nixTools
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
