# Do not modify! This file is generated.
{
  inputs = {
    Hyprspace = {
      inputs.hyprland.follows = "hyprland";
      owner = "KZDKM";
      repo = "Hyprspace";
      type = "github";
    };
    ags = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "Aylur";
      repo = "ags";
      type = "github";
    };
    arion = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "hercules-ci";
      repo = "arion";
      type = "github";
    };
    astal = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "Aylur";
      repo = "Astal";
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
    curseforge-server-downloader-src = {
      flake = false;
      owner = "Malpiszonekx4";
      repo = "curseforge-server-downloader";
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
    firefox-gx-src = {
      flake = false;
      owner = "Godiesc";
      repo = "firefox-gx";
      rev = "dde9941d4bf78b94d76bf06cccb2d1dce5372c56";
      type = "github";
    };
    flakegen.url = "github:jorsn/flakegen";
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
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "juanfont";
      repo = "headscale";
      type = "github";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "matt1432";
      ref = "fix-mpv-pkg";
      repo = "home-manager";
      type = "github";
    };
    hypr-official-plugins = {
      inputs.hyprland.follows = "hyprland";
      owner = "hyprwm";
      repo = "hyprland-plugins";
      type = "github";
    };
    hyprland = {
      inputs.nixpkgs.follows = "nixpkgs";
      submodules = true;
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
    };
    jellyfin-flake = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "matt1432";
      repo = "nixos-jellyfin";
      type = "github";
    };
    jellyfin-ultrachromic-src = {
      flake = false;
      owner = "CTalvio";
      repo = "Ultrachromic";
      type = "github";
    };
    libratbag-src = {
      flake = false;
      owner = "libratbag";
      repo = "libratbag";
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
    neovim-nightly = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "nix-community";
      repo = "neovim-nightly-overlay";
      type = "github";
    };
    nh = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "viperML";
      repo = "nh";
      type = "github";
    };
    nix-eval-jobs = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "nix-community";
      ref = "release-2.21";
      repo = "nix-eval-jobs";
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
    nix-melt = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "nix-community";
      repo = "nix-melt";
      type = "github";
    };
    nix-on-droid = {
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "nix-community";
      repo = "nixpkgs-wayland";
      type = "github";
    };
    nms = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "matt1432";
      repo = "nixos-minecraft-servers";
      type = "github";
    };
    nur = {
      owner = "nix-community";
      repo = "NUR";
      type = "github";
    };
    nurl = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "matt1432";
      repo = "nurl";
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
    secrets = {
      inputs.nixpkgs.follows = "nixpkgs";
      type = "git";
      url = "ssh://git@git.nelim.org/matt1432/nixos-secrets";
    };
    sioyek-theme-src = {
      flake = false;
      owner = "dracula";
      repo = "sioyek";
      type = "github";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "Mic92";
      repo = "sops-nix";
      type = "github";
    };
    stylelint-lsp = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "matt1432";
      repo = "stylelint-lsp";
      type = "github";
    };
    subsync = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "matt1432";
      repo = "subsync";
      rev = "ee9e1592ae4ec7c694d8857aa72be079d81ea209";
      type = "github";
    };
    trash-d-src = {
      flake = false;
      owner = "rushsteve1";
      repo = "trash-d";
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
    wpaperd = {
      inputs.nixpkgs.follows = "nixpkgs";
      owner = "danyspin97";
      repo = "wpaperd";
      type = "github";
    };
  };
  outputs = inputs: inputs.flakegen ./flake.in.nix inputs;
}
