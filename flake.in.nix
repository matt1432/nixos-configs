{
  inputs = let
    inherit (import ./inputs.nix) mkDep mkInput otherInputs;

    mainInputs = {
      nixpkgs = mkInput {
        owner = "NixOS";
        repo = "nixpkgs";
        ref = "nixos-unstable";
      };

      home-manager = mkDep {
        owner = "nix-community";
        repo = "home-manager";
      };

      nix-on-droid = mkDep {
        owner = "nix-community";
        repo = "nix-on-droid";

        inputs.home-manager.follows = "home-manager";
      };

      sops-nix = mkDep {
        owner = "Mic92";
        repo = "sops-nix";
      };

      secrets = mkDep {
        type = "git";
        url = "ssh://git@git.nelim.org/matt1432/nixos-secrets";

        inputs.sops-nix.follows = "sops-nix";
      };
    };
  in
    mainInputs // otherInputs;

  outputs = inputs @ {
    self,
    nixpkgs,
    secrets,
    ...
  }: let
    supportedSystems = ["x86_64-linux" "aarch64-linux"];

    perSystem = attrs:
      nixpkgs.lib.genAttrs supportedSystems (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        attrs system pkgs);

    # Default system
    mkNixOS = mods:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules =
          [
            {home-manager.extraSpecialArgs = inputs;}
            ./common
          ]
          ++ mods;
      };
  in {
    nixosConfigurations = {
      wim = mkNixOS [
        ./devices/wim
        secrets.nixosModules.default
      ];
      binto = mkNixOS [./devices/binto];

      nos = mkNixOS [
        ./devices/nos
        secrets.nixosModules.nos
      ];

      servivi = mkNixOS [
        ./devices/servivi
        secrets.nixosModules.servivi
      ];

      # Cluster
      thingone = mkNixOS [
        (import ./devices/cluster "thingone")
        secrets.nixosModules.thingy
      ];
      thingtwo = mkNixOS [
        (import ./devices/cluster "thingtwo")
        secrets.nixosModules.thingy
      ];

      live-image = mkNixOS [
        ("${nixpkgs}/nixos/modules/installer/"
          + "cd-dvd/installation-cd-minimal.nix")
        {home-manager.users.nixos.home.stateVersion = "24.05";}
        {
          vars = {
            mainUser = "nixos";
            hostName = "nixos";
          };
        }
      ];
    };

    nixOnDroidConfigurations.default = import ./devices/android inputs;

    formatter = perSystem (_: pkgs: pkgs.alejandra);

    # CI: https://github.com/Mic92/dotfiles/blob/c2f538934d67417941f83d8bb65b8263c43d32ca/flake.nix#L168
    checks = perSystem (system: pkgs: let
      inherit (pkgs.lib) filterAttrs mapAttrs' nameValuePair;

      nixosMachines = mapAttrs' (
        name: config: nameValuePair "nixos-${name}" config.config.system.build.toplevel
      ) ((filterAttrs (_: config: config.pkgs.system == system)) self.nixosConfigurations);
      devShells = mapAttrs' (n: nameValuePair "devShell-${n}") self.devShells;
    in
      nixosMachines // devShells);

    devShells = perSystem (_: pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          alejandra
          git

          (writeShellScriptBin "mkIso" (lib.concatStrings [
            "nix build $(realpath /etc/nixos)#nixosConfigurations."
            "live-image.config.system.build.isoImage"
          ]))
        ];
      };

      ags = pkgs.mkShell {
        packages = with pkgs; [
          nodejs_latest
        ];
      };

      subtitles-dev = pkgs.mkShell {
        packages = with pkgs;
          [
            nodejs_latest
            ffmpeg-full
            typescript
          ]
          ++ (with nodePackages; [
            ts-node
          ]);
      };
    });
  };
}
