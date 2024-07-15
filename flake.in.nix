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
    inherit (import ./lib.nix inputs) mkVersion mkNixOS mkNixOnDroid mkPkgs;

    supportedSystems = ["x86_64-linux" "aarch64-linux"];

    perSystem = attrs:
      nixpkgs.lib.genAttrs supportedSystems (system:
        attrs system (mkPkgs system nixpkgs));
  in {
    nixosModules = {
      adb = import ./modules/adb.nix;
      desktop = import ./modules/desktop;
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

    legacyPackages = perSystem (system: pkgs: let
      mkScope = file:
        pkgs.lib.recurseIntoAttrs
        (pkgs.callPackage file ({inherit mkVersion;} // inputs));
    in {
      dracula = mkScope ./pkgs/dracula;
      firefoxAddons = mkScope ./pkgs/firefox-addons;
      mpvScripts = mkScope ./pkgs/mpv-scripts;
    });

    packages =
      perSystem (system: pkgs:
        import ./pkgs ({inherit self system pkgs mkVersion;} // inputs));

    devShells = perSystem (_: pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          alejandra
          git
          nix-output-monitor

          (writeShellScriptBin "mkIso" (lib.concatStrings [
            "nom build $(realpath /etc/nixos)#nixosConfigurations."
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
