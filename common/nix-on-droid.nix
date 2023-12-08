{
  config,
  nixpkgs,
  nur,
  pkgs,
  ...
}: {
  imports = [
    ./vars.nix
    ./pkgs
    nur.nixosModules.nur
  ];

  nix = {
    # Edit nix.conf
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
      auto-optimise-store = true
      warn-dirty = false
    '';

    # Minimize dowloads of indirect nixpkgs flakes
    registry.nixpkgs = {
      flake = nixpkgs;
      exact = false;
    };

    substituters = [
      # Neovim and stuff
      "https://nix-community.cachix.org"
    ];
    trustedPublicKeys = [
      # Neovim and stuff
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  # Global hm settings
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    config = {
      imports = [
        # Make the vars be the same on Nix and HM
        ./vars.nix
        {vars = config.vars;}

        nur.hmModules.nur

        ./home
        ./pkgs
      ];

      home.packages =
        [
          config.customPkgs.repl
        ]
        ++ (with pkgs.nodePackages; [
          undollar
        ])
        ++ (with pkgs; [
          dracula-theme
          neofetch
          progress
          wget
          tree
          mosh
          rsync
          killall
          imagemagick
          usbutils
        ]);

      home.stateVersion = "23.05";
    };
  };
}
