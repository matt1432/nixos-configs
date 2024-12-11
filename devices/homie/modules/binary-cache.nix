{
  config,
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

      nix-fast-build -f ..#nixFastChecks.${pkgs.system}.aptDevices "$@"
    '';
  };
in {
  services.nix-serve = {
    enable = true;
    secretKeyFile = secrets.apt-binary-cache-key.path;
  };

  environment.systemPackages = [pkgs.nix-fast-build nixFastBuild];
}
