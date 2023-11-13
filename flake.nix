{
  description = "Basic example of Nix-on-Droid system config.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    neovim-flake = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nurl = {
      url = "github:nix-community/nurl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-melt = {
      url = "github:nix-community/nix-melt";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    coc-stylelintplus = {
      url = "github:matt1432/coc-stylelintplus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nix-on-droid,
    home-manager,
    coc-stylelintplus,
    neovim-flake,
    ...
  } @ attrs: {
    nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
      extraSpecialArgs = attrs;

      pkgs = import nixpkgs {
        system = "aarch64-linux";

        overlays = [
          nix-on-droid.overlays.default
          coc-stylelintplus.overlay
          (final: prev: {
            neovim-nightly = neovim-flake.packages."${prev.system}".default.override {
              libvterm-neovim =
                prev.libvterm-neovim.overrideAttrs
                (prev': final': {
                  doCheck = false;
                  version = "0.3.3";
                  src = prev.fetchurl {
                    url = "https://launchpad.net/libvterm/trunk/v0.3.3/+download/libvterm-0.3.3.tar.gz";
                    hash = "sha256-CRVvQ90hKL00fL7r5Q2aVx0yxk4M8Y0hEZeUav9yJuA=";
                  };
                });
            };
          })
        ];
      };

      modules = [
        ./cachix.nix

        {
          nix = {
            extraOptions = ''
              experimental-features = nix-command flakes
            '';

            registry.nixpkgs = {
              flake = nixpkgs;
              exact = false;
            };
          };
        }

        {
          home-manager = {
            extraSpecialArgs = attrs;
          };
        }

        ./nix-on-droid.nix
      ];

      home-manager-path = home-manager.outPath;
    };
  };
}
