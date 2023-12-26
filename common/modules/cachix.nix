{...}: {
  nix = {
    settings = {
      substituters = [
        "https://hyprland.cachix.org"
        "https://nix-gaming.cachix.org"
        # Nixpkgs-Wayland
        "https://cache.nixos.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://nix-community.cachix.org"
        # Neovim and stuff
        "https://nix-community.cachix.org"
        # Nh
        "https://viperml.cachix.org"
        # Caddy
        "https://caddycf.cachix.org"
        # Personal config cache
        "https://cache.nelim.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        # Nixpkgs-Wayland
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        # Neovim and stuff
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        # Nh
        "viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8="
        # Caddy
        "caddycf.cachix.org-1:6vbQaeiec/zKv9XfEwi9yWVCe7opbeJMu6w81UEXugY="
        # Personal config cache
        "cache.nelim.org:JmFqkUdH11EA9EZOFAGVHuRYp7EbsdJDHvTQzG2pPyY="
      ];
    };
  };
}
