# nix-daemon was flagged by SentinelOne on darwin so this is a workaround for a single-user installation of nix
self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) toJSON;

  inherit (lib) isCoercibleToString toPretty;

  inherit (lib.attrsets) attrValues filterAttrs isDerivation mapAttrsToList;
  inherit (lib.lists) isList;
  inherit (lib.modules) mkForce mkIf;
  inherit (lib.trivial) boolToString isBool isFloat isInt;

  inherit
    (lib.strings)
    concatStringsSep
    escape
    floatToString
    getVersion
    hasPrefix
    isString
    optionalString
    versionAtLeast
    ;

  inherit (self.inputs) home-manager;
  inherit (pkgs.stdenv.hostPlatform) isDarwin;

  cfg = config.roles.base;
  cfgNix = config.nix;

  # https://github.com/nix-darwin/nix-darwin/blob/master/modules/nix/default.nix
  nixPackage = cfgNix.package.out;
  isNixAtLeast = versionAtLeast (getVersion nixPackage);
  nixConf = assert isNixAtLeast "2.2"; let
    mkValueString = v:
      if v == null
      then ""
      else if isInt v
      then toString v
      else if isBool v
      then boolToString v
      else if isFloat v
      then floatToString v
      else if isList v
      then toString v
      else if isDerivation v
      then toString v
      else if builtins.isPath v
      then toString v
      else if isString v
      then v
      else if isCoercibleToString v
      then toString v
      else abort "The nix conf value: ${toPretty {} v} can not be encoded";

    mkKeyValue = k: v: "${escape ["="] k} = ${mkValueString v}";

    mkKeyValuePairs = attrs: concatStringsSep "\n" (mapAttrsToList mkKeyValue attrs);

    isExtra = key: hasPrefix "extra-" key;
  in
    pkgs.writeTextFile {
      name = "nix.conf";
      text = ''
        # WARNING: this file is generated from the nix.* options in
        # your nix-darwin configuration. Do not edit it!
        ${mkKeyValuePairs (filterAttrs (key: value: !(isExtra key)) cfgNix.settings)}
        ${mkKeyValuePairs (filterAttrs (key: value: isExtra key) cfgNix.settings)}
        ${cfgNix.extraOptions}
      '';
      checkPhase =
        if pkgs.stdenv.hostPlatform != pkgs.stdenv.buildPlatform
        then ''
          echo "Ignoring validation for cross-compilation"
        ''
        else let
          showCommand =
            if isNixAtLeast "2.20pre"
            then "config show"
            else "show-config";
        in ''
          echo "Validating generated nix.conf"
          ln -s $out ./nix.conf
          set -e
          set +o pipefail
          NIX_CONF_DIR=$PWD \
            ${cfgNix.package}/bin/nix ${showCommand} ${optionalString (isNixAtLeast "2.3pre") "--no-net"} \
              ${optionalString (isNixAtLeast "2.4pre") "--option experimental-features nix-command"} \
            |& sed -e 's/^warning:/error:/' \
            | (! grep '"^error:"')
          set -o pipefail
        '';
    };
in {
  config = mkIf (cfg.enable && isDarwin) {
    # nix-darwin only supports multi-user, so we reimplement the things we need
    nix = {
      enable = false;

      settings = {
        build-users-group = mkForce null;
        trusted-users = ["root" cfg.user];
      };
    };

    environment.systemPackages = attrValues {
      inherit nixPackage;
      inherit (pkgs) nix-info nix-bash-completions;
    };

    environment.etc."nix/nix.conf".source = nixConf;

    environment.etc."nix/registry.json".text = toJSON {
      version = 2;
      flakes = mapAttrsToList (n: v: {inherit (v) from to exact;}) cfgNix.registry;
    };

    environment.variables = {
      NIX_REMOTE = "local";
      NIX_PATH = cfgNix.nixPath;
    };

    environment.extraSetup = mkIf (!cfgNix.channel.enable) ''
      rm --force $out/bin/nix-channel
    '';

    home-manager.users.${cfg.user} = {
      home.extraActivationPath = [nixPackage];

      # This is needed to force all nix calls inside the activation to not use the nix-daemon
      # Maybe there's a better way?
      # https://github.com/nix-community/home-manager/blob/daa2c221320809f5514edde74d0ad0193ad54ed8/modules/home-environment.nix#L743
      lib.bash.initHomeManagerLib = let
        domainDir =
          pkgs.runCommand "hm-modules-messages"
          {
            nativeBuildInputs = [pkgs.buildPackages.gettext];
          }
          ''
            for path in ${"${home-manager}/modules/po"}/*.po; do
              lang="''${path##*/}"
              lang="''${lang%%.*}"
              mkdir -p "$out/$lang/LC_MESSAGES"
              msgfmt -o "$out/$lang/LC_MESSAGES/hm-modules.mo" "$path"
            done
          '';
      in ''
        export NIX_REMOTE=local
        export TEXTDOMAIN=hm-modules
        export TEXTDOMAINDIR=${domainDir}
        source ${"${home-manager}/lib/bash/home-manager.sh"}
      '';
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
