{
  inputs = let
    inherit (import ./inputs.nix) mkDep mkInput otherInputs;

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
    };
  in
    mainInputs // otherInputs;

  outputs = inputs @ {
    self,
    nixpkgs,
    secrets,
    ...
  }: let
    inherit (import ./lib.nix inputs) mkNixOS mkNixOnDroid mkPkgs;

    supportedSystems = ["x86_64-linux" "aarch64-linux"];

    perSystem = attrs:
      nixpkgs.lib.genAttrs supportedSystems (system:
        attrs system (mkPkgs system nixpkgs));
  in {
    nixosConfigurations = {
      # Desktops
      wim = mkNixOS [
        ./devices/wim
        secrets.nixosModules.default
      ];
      binto = mkNixOS [./devices/binto];

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

    nixOnDroidConfigurations.default = mkNixOnDroid [./devices/android];

    packages =
      perSystem (system: pkgs:
        import ./pkgs ({inherit self system pkgs;} // inputs));

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

    formatter = perSystem (_: pkgs: pkgs.alejandra);

    # For nix-fast-build
    checks =
      perSystem (system: pkgs:
        import ./ci.nix {inherit system pkgs self;});
  };
}
