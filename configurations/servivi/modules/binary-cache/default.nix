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

      # TODO: re-enable this when homie is back up
      # Home-assistant sometimes fails some tests when built with everything else
      # hass="..#nixosConfigurations.homie.config.services.home-assistant.package"
      # i=0

      # while ! nom build --no-link "$hass"; do
      #     echo "Retrying to build home-assistant"
      #     i=$((i+1))

      #     if [[ "$i" -ge 5 ]]; then
      #         break
      #     fi
      # done

      exec nix-fast-build \
          --eval-workers 6 \
          --eval-max-memory-size 3072 \
          -f ..#nixFastChecks.all "$@"
    '';
  };

  listDeprecations = pkgs.writeShellApplication {
    name = "listDeprecations";

    runtimeInputs = attrValues {
      inherit
        (pkgs)
        ripgrep
        ;

      inherit nixFastBuild;
    };

    text = ''
      nixFastBuild |& rg -M 0 -r "" '.*trace: evaluation warning: ' | sort -n | uniq
    '';
  };
in {
  services.nix-serve = {
    enable = true;
    secretKeyFile = secrets.binary-cache-key.path;
  };

  environment.systemPackages = [
    pkgs.nix-fast-build
    nixFastBuild
    listDeprecations
  ];

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
