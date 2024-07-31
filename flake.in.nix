{
  inputs = let
    inherit (import ./flake/inputs.nix) mkDep mkInput otherInputs;

    mainInputs = {
      nixpkgs = mkInput {
        owner = "NixOS";
        repo = "nixpkgs";
        ref = "nixos-unstable-small";
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

      jovian = mkDep {
        owner = "Jovian-Experiments";
        repo = "Jovian-NixOS";
      };
    };
  in
    mainInputs // otherInputs;

  outputs = inputs @ {
    nixpkgs,
    secrets,
    self,
    ...
  }: let
    inherit (import ./flake/lib.nix inputs) mkVersion mkNixOS mkNixOnDroid mkPkgs;

    supportedSystems = ["x86_64-linux" "aarch64-linux"];

    perSystem = attrs:
      nixpkgs.lib.genAttrs supportedSystems (system:
        attrs (mkPkgs system nixpkgs));
  in {
    nixosModules = {
      adb = import ./modules/adb.nix;
      desktop = import ./modules/desktop;
      docker = import ./modules/docker;
      nvidia = import ./modules/nvidia.nix;
      plymouth = import ./modules/plymouth.nix;
    };

    nixosConfigurations = {
      # Desktops
      wim = mkNixOS [
        ./devices/wim
        secrets.nixosModules.default
      ];
      binto = mkNixOS [./devices/binto];

      bbsteamie = mkNixOS [./devices/bbsteamie];

      # NAS
      nos = mkNixOS [
        ./devices/nos
        secrets.nixosModules.nos
      ];

      # Build / test server
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
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        {home-manager.users.nixos.home.stateVersion = "24.05";}
        {
          vars = {
            mainUser = "nixos";
            hostName = "nixos";
          };
        }
      ];
    };

    nixOnDroidConfigurations.default =
      mkNixOnDroid [./devices/android];

    legacyPackages =
      perSystem (pkgs:
        import ./legacyPackages {inherit mkVersion pkgs inputs;});

    packages =
      perSystem (pkgs:
        import ./packages {inherit self pkgs mkVersion inputs;});

    apps =
      perSystem (pkgs:
        import ./apps {inherit inputs pkgs;});

    devShells = perSystem (pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          (writeShellScriptBin "mkIso" ''
            isoConfig="nixosConfigurations.live-image.config.system.build.isoImage"
            nom build $(realpath /etc/nixos)#$isoConfig
          '')
        ];
      };

      node = pkgs.mkShell {
        packages = with pkgs;
          [
            nodejs_latest
            typescript
          ]
          ++ (with nodePackages; [
            ts-node
          ]);
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

    # For nix-fast-build
    checks =
      perSystem (pkgs:
        import ./flake/ci.nix {inherit pkgs self;});

    formatter = perSystem (pkgs: pkgs.alejandra);
  };
}
