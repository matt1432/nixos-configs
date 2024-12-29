self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.lib) capitalise;

  inherit (lib) types;
  inherit (lib.attrsets) attrValues;
  inherit (lib.modules) mkIf mkOverride;
  inherit (lib.options) mkOption;
  inherit (lib.strings) concatMapStringsSep concatStringsSep optionalString;

  cfg = config.services.caddy;

  mkSubDirConf = subOpts:
    optionalString (subOpts.reverseProxy != null) (
      if subOpts.experimental
      then ''
        ${subOpts.extraConfig}

        redir /${subOpts.subDirName} /${subOpts.subDirName}/
        route /${subOpts.subDirName}/* {
          uri strip_prefix ${subOpts.subDirName}
          reverse_proxy ${subOpts.reverseProxy} {
            header_up X-Real-IP {remote}
            header_up X-${capitalise subOpts.subDirName}-Base "/${subOpts.subDirName}"
          }
        }
      ''
      else ''
        ${subOpts.extraConfig}

        redir /${subOpts.subDirName} /${subOpts.subDirName}/
        reverse_proxy /${subOpts.subDirName}/* {
          to ${subOpts.reverseProxy}
        }
      ''
    );

  mkSubDomainConf = hostName: subOpts: ''
    @${subOpts.subDomainName} host ${subOpts.subDomainName}.${hostName}
    handle @${subOpts.subDomainName} {
      ${subOpts.extraConfig}
      ${optionalString (subOpts.reverseProxy != null) "reverse_proxy ${subOpts.reverseProxy}"}

      ${concatMapStringsSep "\n" mkSubDirConf (attrValues subOpts.subDirectories)}
    }
  '';

  mkVHostConf = hostOpts: let
    sslCertDir = config.security.acme.certs.${hostOpts.useACMEHost}.directory;
  in ''
    ${hostOpts.hostName} ${concatStringsSep " " hostOpts.serverAliases} {
      ${optionalString (hostOpts.listenAddresses != []) "bind ${concatStringsSep " " hostOpts.listenAddresses}"}
      ${optionalString (hostOpts.useACMEHost != null) "tls ${sslCertDir}/cert.pem ${sslCertDir}/key.pem"}
      log {
        ${hostOpts.logFormat}
      }

      ${hostOpts.extraConfig}
      ${optionalString (hostOpts.reverseProxy != null) "reverse_proxy ${hostOpts.reverseProxy}"}
      ${concatMapStringsSep "\n" mkSubDirConf (attrValues hostOpts.subDirectories)}
      ${concatMapStringsSep "\n" (mkSubDomainConf hostOpts.hostName) (attrValues hostOpts.subDomains)}
    }
  '';

  settingsFormat = pkgs.formats.json {};

  configFile =
    if cfg.settings != {}
    then settingsFormat.generate "caddy.json" cfg.settings
    else let
      Caddyfile = pkgs.writeTextDir "Caddyfile" ''
        {
          ${cfg.globalConfig}
        }
        ${cfg.extraConfig}
        ${concatMapStringsSep "\n" mkVHostConf (attrValues cfg.virtualHosts)}
      '';

      Caddyfile-formatted = pkgs.runCommand "Caddyfile-formatted" {nativeBuildInputs = [cfg.package];} ''
        mkdir -p $out
        cp --no-preserve=mode ${Caddyfile}/Caddyfile $out/Caddyfile
        caddy fmt --overwrite $out/Caddyfile
      '';
    in "${
      if pkgs.stdenv.buildPlatform == pkgs.stdenv.hostPlatform
      then Caddyfile-formatted
      else Caddyfile
    }/Caddyfile";
in {
  options.services.caddy.virtualHosts = mkOption {
    type = types.attrsOf (types.submodule (import ./vhost-options.nix {inherit cfg;}));
  };

  config = mkIf cfg.enable {
    services.caddy.configFile = mkOverride 80 configFile;
  };

  # For accurate stack trace
  _file = ./default.nix;
}
