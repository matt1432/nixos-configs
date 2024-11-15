# Do not modify! This file is generated.
{
  inputs = {
    ags = {
      inputs = {
        astal.follows = "astal";
        nixpkgs.follows = "nixpkgs";
      };
      owner = "Aylur";
      repo = "ags";
      type = "github";
    };
    astal = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "Aylur";
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
    caddy-plugins = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "matt1432";
      repo = "nixos-caddy-cloudflare";
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
    discord-overlay = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "matt1432";
      repo = "discord-nightly-overlay";
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
    firefox-gx-src = {
      flake = false;
      owner = "Godiesc";
      repo = "firefox-gx";
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
    gtk-session-lock = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "Cu3PO42";
      repo = "gtk-session-lock";
      type = "github";
    };
    gtk-theme-src = {
      flake = false;
      owner = "dracula";
      repo = "gtk";
      type = "github";
    };
    ha-fallback-conversation-src = {
      flake = false;
      owner = "m50";
      repo = "ha-fallback-conversation";
      type = "github";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "nix-community";
      repo = "home-manager";
      type = "github";
    };
    hyprgrass = {
      inputs.hyprland.follows = "hyprland";
      owner = "horriblename";
      repo = "hyprgrass";
      rev = "df4f1e9f3c7b17b8c3dbbc9207fef75bdda6a5c5";
      type = "github";
    };
    hyprland = {
      inputs = {
        hyprutils.follows = "hyprutils";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      owner = "hyprwm";
      repo = "Hyprland";
      type = "github";
    };
    hyprland-plugins = {
      inputs = {
        hyprland.follows = "hyprland";
        systems.follows = "systems";
      };
      owner = "hyprwm";
      repo = "hyprland-plugins";
      rev = "810c1377e0b987bb9521dc33163633aa0642c1d3";
      type = "github";
    };
    hyprpaper = {
      inputs = {
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
    hyprutils = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      owner = "hyprwm";
      repo = "hyprutils";
      type = "github";
    };
    jellyfin-flake = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "matt1432";
      repo = "nixos-jellyfin";
      type = "github";
    };
    jovian = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "Jovian-Experiments";
      repo = "Jovian-NixOS";
      type = "github";
    };
    khepri = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "matt1432";
      repo = "khepri";
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
    material-rounded-theme-src = {
      flake = false;
      owner = "Nerwyn";
      repo = "material-rounded-theme";
      type = "github";
    };
    material-symbols-src = {
      flake = false;
      owner = "beecho01";
      repo = "material-symbols";
      type = "github";
    };
    minix = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "matt1432";
      repo = "Minix";
      type = "github";
    };
    modernx-src = {
      flake = false;
      owner = "cyl0";
      repo = "ModernX";
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
      owner = "viperML";
      repo = "nh";
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
    nixpkgs = {
      owner = "NixOS";
      ref = "nixos-unstable";
      repo = "nixpkgs";
      type = "github";
    };
    nixpkgs-wayland = {
      inputs = {
        lib-aggregate.follows = "lib-aggregate";
        nixpkgs.follows = "nixpkgs";
      };
      owner = "nix-community";
      repo = "nixpkgs-wayland";
      type = "github";
    };
    nvim-theme-src = {
      flake = false;
      owner = "Mofiqul";
      repo = "dracula.nvim";
      type = "github";
    };
    pam-fprint-grosshack-src = {
      flake = false;
      owner = "mishakmak";
      repo = "pam-fprint-grosshack";
      type = "gitlab";
    };
    pcsd = {
      inputs.nixpkgs.follows = "nixpkgs";
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
    protonhax-src = {
      flake = false;
      owner = "jcnils";
      repo = "protonhax";
      type = "github";
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
    systems = {
      owner = "nix-systems";
      repo = "default-linux";
      type = "github";
    };
    trash-d-src = {
      flake = false;
      owner = "rushsteve1";
      repo = "trash-d";
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
    vimplugin-ts-error-translator-src = {
      flake = false;
      owner = "dmmulroy";
      repo = "ts-error-translator.nvim";
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
  outputs = inputs: inputs.flakegen ./outputs.nix inputs;
}
