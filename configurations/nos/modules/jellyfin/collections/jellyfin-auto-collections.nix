{
  config,
  lib,
  pkgs,
  jellyfin-auto-collections,
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

  inherit (config.sops) secrets;

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
      default = pkgs.jellyfin-auto-collections;
      defaultText = literalExpression "pkgs.callPackage ./package.nix {inherit jellyfin-auto-collections-src;}";
    };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = {};
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [jellyfin-auto-collections.overlays.default];

    systemd.services.jellyfin-auto-collections = {
      wantedBy = ["multi-user.target"];
      wants = ["network-online.target"];
      after = ["network-online.target" "jellyfin.service"];

      serviceConfig = {
        DynamicUser = true;
        RuntimeDirectory = "jellyfin-auto-collections";
        WorkingDirectory = "%t/jellyfin-auto-collections";

        EnvironmentFile = secrets.jellyfin-auto-collections.path;

        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${getExe cfg.package} --config ${configFile}";
      };
    };
  };
}
