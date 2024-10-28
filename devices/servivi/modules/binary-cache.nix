{
  config,
  nix-fast-build,
  pkgs,
  ...
}: let
  inherit (config.vars) mainUser;
  inherit (config.sops) secrets;

  nix-fast-build-pkg = nix-fast-build.packages.${pkgs.system}.nix-fast-build.override {
    nix-eval-jobs =
      pkgs.nix-eval-jobs.override {
        nix = config.nix.package;
      }
      // {
        nix = config.nix.package;
      };
  };

  nixFastBuild = pkgs.writeShellApplication {
    name = "nixFastBuild";
    runtimeInputs = with pkgs; [gnugrep nix-fast-build-pkg];
    text = ''
      cd "$FLAKE" || return

      nix-fast-build -f .#nixFastChecks
    '';
  };
in {
  services.nix-serve = {
    enable = true;
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

      path =
        [
          nix-fast-build-pkg
          config.nix.package
        ]
        ++ (builtins.attrValues {
          inherit
            (pkgs)
            bash
            git
            openssh
            ;
        });

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
