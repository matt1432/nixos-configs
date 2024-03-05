{
  config,
  jellyfin-flake,
  lib,
  ...
}: let
  inherit (lib) hasAttr fileContents optionals;
  inherit (config.vars) mainUser;

  optionalGroup = name:
    optionals
    (hasAttr name config.users.groups)
    [config.users.groups.${name}.name];
in {
  imports = [
    ./jfa-go.nix
    ./packages.nix
    jellyfin-flake.nixosModules.default
  ];

  users.users."jellyfin".extraGroups =
    optionalGroup mainUser
    ++ optionalGroup "input"
    ++ optionalGroup "media"
    ++ optionalGroup "render";

  services = {
    jellyfin = {
      enable = true;

      settings = {
        general = {
          serverName = "Jelly";

          quickConnectAvailable = false;
          isStartupWizardCompleted = true;

          branding.customCss = ''
          '';
        };

        libraries.display = {
          enableGroupingIntoCollections = true;
          enableExternalContentInSuggestions = false;
        };

        playback.transcoding = {
          hardwareAccelerationType = "nvenc";
          hardwareDecodingCodecs = ["h264" "hevc" "mpeg2video" "mpeg4" "vc1" "vp8" "vp9" "av1"];
          enableThrottling = true;
          enableTonemapping = true;
          downMixAudioBoost = 1;
        };

        advanced.logs.enableSlowResponseWarning = false;
      };
    };

    nginx = {
      enable = true;
      config = fileContents ./nginx.conf;
    };
  };
}
