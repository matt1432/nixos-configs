{ home-manager, lib, nixpkgs, nur, ... }: {
  imports = [
    home-manager.nixosModules.default
    ./overlays/list.nix
  ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";
  console = {
    keyMap = "ca";
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    # Edit nix.conf
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      keep-outputs = true;
      keep-derivations = true;
      auto-optimise-store = true;
      warn-dirty = false;
    };

    # Minimize dowloads of indirect nixpkgs flakes
    registry.nixpkgs = {
      flake = nixpkgs;
      exact = false;
    };
  };

  home-manager.users = let
    default = {
      imports = [
        nur.hmModules.nur
        ./modules/neovim
        ./modules/bash
      ];
      home.stateVersion = lib.mkDefault "23.05";
    };
  in {
    root = default;
    matt = default;
  };
}
