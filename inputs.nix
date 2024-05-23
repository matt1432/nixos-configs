let
  inherit (builtins) listToAttrs map removeAttrs;

  # Misc functions
  mkInput = {type ? "github", ...} @ info: info // {inherit type;};
  mkDep = info: (mkInput info) // {inputs.nixpkgs.follows = "nixpkgs";};
  mkHyprDep = info: (mkInput info) // {inputs.hyprland.follows = "hyprland";};
  mkSrc = info: (mkInput info) // {flake = false;};

  # Inputs
  nixTools = {
    nurl = mkInput {
      owner = "nix-community";
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
  };

  overlays = {
    nixpkgs-wayland = mkDep {
      owner = "nix-community";
      repo = "nixpkgs-wayland";
    };

    nur = mkInput {
      owner = "nix-community";
      repo = "NUR";
    };

    nix-gaming = mkDep {
      owner = "fufexan";
      repo = "nix-gaming";
    };
  };

  nvimInputs = {
    neovim-nightly = mkInput {
      owner = "nix-community";
      repo = "neovim-nightly-overlay";

      # FIXME: issue with grammars on latest unstable
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    stylelint-lsp = mkDep {
      owner = "matt1432";
      repo = "stylelint-lsp";
    };

    nixd = mkDep {
      owner = "nix-community";
      repo = "nixd";
    };

    # FIXME: get it from nixpkgs when it gets merged
    basedpyright.url = "github:kiike/nixpkgs/pkgs/basedpyright";
  };

  clusterInputs = {
    pcsd = mkDep {
      owner = "matt1432";
      repo = "nixos-pcsd";
    };

    headscale = mkDep {
      owner = "juanfont";
      repo = "headscale";

      # FIXME: doesn't work on latest
      rev = "fef8261339899fe526777a7aa42df57ca02021c5";
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

    nix-eval-jobs = mkDep {
      owner = "nix-community";
      repo = "nix-eval-jobs";
      ref = "release-2.21";
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

      hypr-official-plugins = mkHyprDep {
        owner = "hyprwm";
        repo = "hyprland-plugins";
      };

      Hyprspace = mkHyprDep {
        owner = "KZDKM";
        repo = "Hyprspace";
      };

      hypridle = mkDep {
        owner = "hyprwm";
        repo = "hypridle";
      };

      grim-hyprland = mkDep {
        owner = "eriedaberrie";
        repo = "grim-hyprland";
      };

      wpaperd = mkDep {
        owner = "danyspin97";
        repo = "wpaperd";
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
      ref = "v.9.1";
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
      owner = "dracula";
      repo = "xresources";
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
