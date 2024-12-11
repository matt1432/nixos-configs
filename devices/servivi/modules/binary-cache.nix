{
  config,
  mainUser,
  nix-eval-jobs,
  nix-fast-build,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;

  nix-fast-build-pkg = nix-fast-build.packages.${pkgs.system}.nix-fast-build.override {
    nix-eval-jobs =
      nix-eval-jobs.packages.${pkgs.system}.default.override {
        nix = config.nix.package;
      }
      // {
        nix = config.nix.package;
      };
  };

  nixFastBuild = pkgs.writeShellApplication {
    name = "nixFastBuild";

    runtimeInputs = builtins.attrValues {
      inherit
        (pkgs)
        gnugrep
        nix-output-monitor
        ;

      inherit nix-fast-build-pkg;
    };

    text = ''
      cd "$FLAKE" || return

      # Home-assistant sometimes fails some tests when built with everything else
      nom build --no-link \
        .#nixosConfigurations.homie.config.services.home-assistant.package

      nix-fast-build -f .#nixFastChecks "$@"

      mkdir -p results
      mv -f result-* results
    '';
  };
in {
  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    secretKeyFile = secrets.binary-cache-key.path;
  };

  environment.systemPackages = [nix-fast-build-pkg nixFastBuild];

  # Populate cache
  systemd = {
    services.buildAll = {
      serviceConfig = {
        Type = "oneshot";
        User = mainUser;
        Group = config.users.users.${mainUser}.group;
      };

      path = builtins.attrValues {
        inherit
          (pkgs)
          bash
          git
          openssh
          ;

        inherit (config.nix) package;

        inherit nix-fast-build-pkg;
      };

      script = ''
        cd /tmp

        if [[ -d ./nix-clone ]]; then
            rm -r ./nix-clone
        fi

        git clone https://git.nelim.org/matt1432/nixos-configs.git nix-clone
        cd nix-clone

        nix-fast-build -f .#nixFastChecks

        cd ..
        rm -r nix-clone

        # Just to cache mozilla-addons-to-nix
        nix run sourcehut:~rycee/mozilla-addons-to-nix -- --help
      '';
    };

    timers.buildAll = {
      wantedBy = ["timers.target"];
      partOf = ["buildAll.service"];
      timerConfig.OnCalendar = ["0:00:00"];
    };
  };
}
