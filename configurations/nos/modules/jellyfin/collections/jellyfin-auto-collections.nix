{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    getExe
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  inherit (config.sops.secrets) jellyfin-auto-collections;

  cfg = config.services.jellyfin-auto-collections;

  settingsFormat = pkgs.formats.yaml {};

  configFile = pkgs.runCommandLocal "config.yaml" {} ''
    cp ${settingsFormat.generate "pre-config.yaml" cfg.settings} $out
    sed -i "s/'\(\![^']*\)'/\1/g" $out
  '';
in {
  options.services.jellyfin-auto-collections = {
    enable = mkEnableOption "jellyfin-auto-collections";

    package = mkOption {
      type = types.package;
      default = pkgs.callPackage ./package.nix {};
      defaultText = literalExpression "pkgs.callPackage ./package.nix {}";
    };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    systemd.services.jellyfin-auto-collections = {
      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      after = ["network-online.target" "jellyfin.service"];

      serviceConfig = {
        DynamicUser = true;
        RuntimeDirectory = "jellyfin-auto-collections";
        WorkingDirectory = "%t/jellyfin-auto-collections";

        EnvironmentFile = jellyfin-auto-collections.path;

        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${getExe cfg.package} --config ${configFile}";
      };
    };
  };
}
