# Do not modify! This file is generated.
{
  inputs = {
    ags = {
      inputs = {
        astal.follows = "astal";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      owner = "matt1432";
      ref = "overlay";
      repo = "ags";
      type = "github";
    };
    astal = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      owner = "matt1432";
      ref = "overlay";
      repo = "astal";
      type = "github";
    };
    bat-theme-src = {
      flake = false;
      owner = "matt1432";
      repo = "bat";
      type = "github";
    };
    bazarr-bulk = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "mateoradman";
      repo = "bazarr-bulk";
      type = "github";
    };
    caule-themes-src = {
      flake = false;
      owner = "ricardoquecria";
      repo = "caule-themes-pack-1";
      type = "github";
    };
    custom-sidebar-src = {
      flake = false;
      owner = "elchininet";
      repo = "custom-sidebar";
      type = "github";
    };
    docker-compose = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      owner = "matt1432";
      repo = "nixos-docker-compose";
      type = "github";
    };
    dracul-ha-src = {
      flake = false;
      owner = "berti24";
      repo = "dracul-ha";
      type = "github";
    };
    dracula-plymouth-src = {
      flake = false;
      owner = "matt1432";
      repo = "dracula-plymouth";
      type = "github";
    };
    eisa-scripts-src = {
      flake = false;
      owner = "Eisa01";
      repo = "mpv-scripts";
      type = "github";
    };
    extended-ollama-conversation-src = {
      flake = false;
      owner = "TheNimaj";
      repo = "extended_ollama_conversation";
      type = "github";
    };
    flake-compat = {
      owner = "edolstra";
      repo = "flake-compat";
      type = "github";
    };
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs";
      owner = "hercules-ci";
      repo = "flake-parts";
      type = "github";
    };
    flake-utils = {
      inputs.systems.follows = "systems";
      owner = "numtide";
      repo = "flake-utils";
      type = "github";
    };
    flakegen = {
      inputs.systems.follows = "systems";
      url = "github:jorsn/flakegen";
    };
    git-theme-src = {
      flake = false;
      owner = "dracula";
      repo = "git";
      type = "github";
    };
    gpu-screen-recorder-src = {
      flake = false;
      type = "git";
      url = "https://repo.dec05eba.com/gpu-screen-recorder";
    };
    grim-hyprland = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      owner = "eriedaberrie";
      repo = "grim-hyprland";
      type = "github";
    };
    gtk-theme-src = {
      flake = false;
      owner = "dracula";
      repo = "gtk";
      type = "github";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "nix-community";
      repo = "home-manager";
      type = "github";
    };
    hyprgrass = {
      inputs = {
        hyprland.follows = "hyprland";
        nixpkgs.follows = "nixpkgs";
      };
      owner = "horriblename";
      repo = "hyprgrass";
      type = "github";
    };
    hyprland = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.follows = "pre-commit-hooks";
        systems.follows = "systems";
      };
      owner = "hyprwm";
      repo = "Hyprland";
      type = "github";
    };
    hyprland-plugins = {
      inputs = {
        hyprland.follows = "hyprland";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      owner = "hyprwm";
      repo = "hyprland-plugins";
      type = "github";
    };
    hyprpaper = {
      inputs = {
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      owner = "hyprwm";
      repo = "hyprpaper";
      type = "github";
    };
    jovian = {
      inputs = {
        nix-github-actions.follows = "nix-github-actions";
        nixpkgs.follows = "nixpkgs";
      };
      owner = "Jovian-Experiments";
      repo = "Jovian-NixOS";
      type = "github";
    };
    kapowarr = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        treefmt-nix.follows = "treefmt-nix";
      };
      owner = "matt1432";
      repo = "Kapowarr";
      type = "github";
    };
    komf-src = {
      flake = false;
      owner = "matt1432";
      ref = "personal";
      repo = "komf";
      type = "github";
    };
    kompass = {
      inputs = {
        astal.follows = "astal";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      owner = "kotontrion";
      repo = "kompass";
      type = "github";
    };
    lib-aggregate = {
      inputs.flake-utils.follows = "flake-utils";
      owner = "nix-community";
      repo = "lib-aggregate";
      type = "github";
    };
    libratbag-src = {
      flake = false;
      owner = "libratbag";
      repo = "libratbag";
      type = "github";
    };
    material-symbols-src = {
      flake = false;
      owner = "beecho01";
      repo = "material-symbols";
      type = "github";
    };
    minix = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      owner = "matt1432";
      repo = "Minix";
      type = "github";
    };
    modernz-src = {
      flake = false;
      owner = "Samillion";
      repo = "ModernZ";
      type = "github";
    };
    mpv-persist-properties-src = {
      flake = false;
      owner = "d87";
      repo = "mpv-persist-properties";
      type = "github";
    };
    mpv-pointer-event-src = {
      flake = false;
      owner = "christoph-heinrich";
      repo = "mpv-pointer-event";
      type = "github";
    };
    mpv-touch-gestures-src = {
      flake = false;
      owner = "christoph-heinrich";
      repo = "mpv-touch-gestures";
      type = "github";
    };
    netdaemon-src = {
      flake = false;
      owner = "net-daemon";
      repo = "integration";
      type = "github";
    };
    nh = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "nix-community";
      repo = "nh";
      type = "github";
    };
    nix-eval-jobs = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nix-github-actions.follows = "nix-github-actions";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
      owner = "nix-community";
      ref = "v2.28.1";
      repo = "nix-eval-jobs";
      type = "github";
    };
    nix-fast-build = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
      owner = "Mic92";
      repo = "nix-fast-build";
      type = "github";
    };
    nix-gaming = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
      owner = "fufexan";
      repo = "nix-gaming";
      type = "github";
    };
    nix-github-actions = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "nix-community";
      repo = "nix-github-actions";
      type = "github";
    };
    nix-index-db = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "Mic92";
      repo = "nix-index-database";
      type = "github";
    };
    nix-on-droid = {
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
      owner = "nix-community";
      repo = "nix-on-droid";
      type = "github";
    };
    nix-serve-ng = {
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
      owner = "aristanetworks";
      repo = "nix-serve-ng";
      type = "github";
    };
    nixcord = {
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
      owner = "kaylorben";
      repo = "nixcord";
      type = "github";
    };
    nixd = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
      owner = "nix-community";
      repo = "nixd";
      type = "github";
    };
    nixos-jellyfin = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      owner = "matt1432";
      repo = "nixos-jellyfin";
      type = "github";
    };
    nixpkgs = {
      ref = "nixos-unstable";
      shallow = true;
      type = "git";
      url = "https://github.com/NixOS/nixpkgs";
    };
    nurl = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "nix-community";
      repo = "nurl";
      type = "github";
    };
    nvim-theme-src = {
      flake = false;
      owner = "Mofiqul";
      repo = "dracula.nvim";
      type = "github";
    };
    pcsd = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      owner = "matt1432";
      repo = "nixos-pcsd";
      type = "github";
    };
    piper-src = {
      flake = false;
      owner = "libratbag";
      repo = "piper";
      type = "github";
    };
    pokemon-colorscripts-src = {
      flake = false;
      owner = "phoneybadger";
      repo = "pokemon-colorscripts";
      type = "gitlab";
    };
    pr-tracker = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "matt1432";
      repo = "pr-tracker";
      type = "github";
    };
    pre-commit-hooks = {
      inputs.flake-compat.follows = "flake-compat";
      owner = "cachix";
      repo = "git-hooks.nix";
      type = "github";
    };
    quickshell = {
      inputs.nixpkgs.follows = "nixpkgs";
      type = "git";
      url = "https://git.outfoxxed.me/quickshell/quickshell";
    };
    secrets = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        sops-nix.follows = "sops-nix";
      };
      type = "git";
      url = "ssh://git@git.nelim.org/matt1432/nixos-secrets";
    };
    sioyek-theme-src = {
      flake = false;
      owner = "dracula";
      repo = "sioyek";
      type = "github";
    };
    smartinspect-src = {
      flake = false;
      owner = "thlucas1";
      repo = "SmartInspectPython";
      type = "github";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "Mic92";
      repo = "sops-nix";
      type = "github";
    };
    spotifyplus-src = {
      flake = false;
      owner = "thlucas1";
      repo = "homeassistantcomponent_spotifyplus";
      type = "github";
    };
    spotifywebapi-src = {
      flake = false;
      owner = "thlucas1";
      repo = "SpotifyWebApiPython";
      type = "github";
    };
    subscleaner-src = {
      flake = false;
      owner = "rogs";
      repo = "subscleaner";
      type = "gitlab";
    };
    systems = {
      owner = "nix-systems";
      repo = "default-linux";
      type = "github";
    };
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "numtide";
      repo = "treefmt-nix";
      type = "github";
    };
    ts-for-gir-src = {
      flake = false;
      owner = "gjsify";
      repo = "ts-for-gir";
      type = "github";
    };
    tuya-local-src = {
      flake = false;
      owner = "make-all";
      repo = "tuya-local";
      type = "github";
    };
    vimplugin-easytables-src = {
      flake = false;
      owner = "Myzel394";
      repo = "easytables.nvim";
      type = "github";
    };
    vimplugin-gitsigns-src = {
      flake = false;
      owner = "lewis6991";
      repo = "gitsigns.nvim";
      type = "github";
    };
    vimplugin-nix-develop-src = {
      flake = false;
      owner = "matt1432";
      repo = "nix-develop.nvim";
      type = "github";
    };
    vimplugin-roslyn-src = {
      flake = false;
      owner = "seblj";
      repo = "roslyn.nvim";
      type = "github";
    };
    vimplugin-ts-error-translator-src = {
      flake = false;
      owner = "dmmulroy";
      repo = "ts-error-translator.nvim";
      type = "github";
    };
    virtualkeyboard-adapter = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "horriblename";
      repo = "fcitx-virtualkeyboard-adapter";
      type = "github";
    };
    wakewords-src = {
      flake = false;
      owner = "fwartner";
      repo = "home-assistant-wakewords-collection";
      type = "github";
    };
    yamaha-soundbar-src = {
      flake = false;
      owner = "osk2";
      repo = "yamaha-soundbar";
      type = "github";
    };
  };
  outputs = inputs: inputs.flakegen ./_outputs.nix inputs;
}
