# Do not modify! This file is generated.
{
  inputs = {
    ags = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
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
      ref = "v.9.5";
      repo = "firefox-gx";
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
    headscale = {
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
      owner = "juanfont";
      ref = "v0.23.0";
      repo = "headscale";
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
      type = "github";
    };
    hyprland = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      rev = "b248d59713d99a8338d25f4765fd2f564069f98b";
      submodules = true;
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
    };
    hyprland-plugins = {
      inputs = {
        hyprland.follows = "hyprland";
        systems.follows = "systems";
      };
      owner = "hyprwm";
      repo = "hyprland-plugins";
      type = "github";
    };
    hyprpaper = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
      owner = "hyprwm";
      repo = "hyprpaper";
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
    nh = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "viperML";
      repo = "nh";
      type = "github";
    };
    nix-fast-build = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "Mic92";
      repo = "nix-fast-build";
      type = "github";
    };
    nix-gaming = {
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "nix-community";
      repo = "nixd";
      type = "github";
    };
    nixpkgs = {
      owner = "NixOS";
      ref = "nixos-unstable-small";
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
    subsync = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "matt1432";
      repo = "subsync";
      rev = "ee9e1592ae4ec7c694d8857aa72be079d81ea209";
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
    ts-for-gir-src = {
      flake = false;
      owner = "gjsify";
      repo = "ts-for-gir";
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
  };
  outputs = inputs: inputs.flakegen ./outputs.nix inputs;
}
