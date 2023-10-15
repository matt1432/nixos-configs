({ nixpkgs, ... }: {
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

  imports = [
    ./overlays/list.nix
  ];
})
