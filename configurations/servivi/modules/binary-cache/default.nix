{
  config,
  mainUser,
  pkgs,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (config.sops) secrets;

  nixFastBuild = pkgs.writeShellApplication {
    name = "nixFastBuild";

    runtimeInputs = attrValues {
      inherit
        (pkgs)
        gnugrep
        nix-fast-build
        nix-output-monitor
        ;
    };

    text = ''
      cd "$FLAKE/results" || return

      # Home-assistant sometimes fails some tests when built with everything else
      hass="..#nixosConfigurations.homie.config.services.home-assistant.package"
      while ! nom build --no-link "$hass"; do
          echo "Retrying to build home-assistant"
      done

      # Build NixOnDroid activation package
      nom build --impure -o ./result-aarch64-linux.nixOnDroidConfigurations_default \
          ..#nixOnDroidConfigurations.default.config.build.activationPackage

      nix-fast-build -f ..#nixFastChecks.all "$@"
    '';
  };
in {
  services.nix-serve = {
    enable = true;
    secretKeyFile = secrets.binary-cache-key.path;
  };

  environment.systemPackages = [pkgs.nix-fast-build nixFastBuild];

  # Populate cache
  systemd = {
    services.buildAll = {
      serviceConfig = {
        Type = "oneshot";
        User = mainUser;
        Group = config.users.users.${mainUser}.group;
      };

      path = attrValues {
        inherit
          (pkgs)
          bash
          git
          nix-fast-build
          openssh
          ;

        inherit (config.nix) package;
      };

      script = ''
        cd /tmp

        if [[ -d ./nix-clone ]]; then
            rm -r ./nix-clone
        fi

        git clone https://git.nelim.org/matt1432/nixos-configs.git nix-clone
        cd nix-clone

        nix-fast-build -f .#nixFastChecks.all

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
