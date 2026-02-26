{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    concatMapStringsSep
    getExe
    mkBefore
    mkOption
    types
    ;

  cfg = config.darwin;

  tccutil = pkgs.selfPackages.tccutil;
in {
  options.darwin = {
    # TODO: add full TCC DB declarative control by force deleting it on every activation
    tccutil = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  config = {
    environment.systemPackages = [tccutil];

    system.activationScripts = {
      preActivation.text =
        # bash
        ''
          if ! head -c1 "/Library/Application Support/com.apple.TCC/TCC.db" &>/dev/null; then
              echo "the application running this script does not have full disk access"
              exit 1
          fi
        '';

      # Grant permissions before we start launchd services that use these programs
      launchd.text = let
        tccExe = getExe tccutil;
      in
        mkBefore (
          concatMapStringsSep "\n" (
            app:
            # bash
            ''
              echo "granting accessibilty permissions to ${baseNameOf app}"

              for entry in $(${tccExe} -l); do
                  if [[ "${app}" != "$entry" ]] && [[ "$(basename "${app}")" == "$(basename "$entry")" ]]; then
                      ${tccExe} -r "$entry"
                  fi
              done

              ${tccExe} --insert ${app}
              ${tccExe} --enable ${app}
            ''
          )
          cfg.tccutil
        );
    };
  };
}
