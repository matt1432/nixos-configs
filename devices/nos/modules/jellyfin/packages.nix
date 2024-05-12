{
  config,
  jellyfin-overlays,
  pkgs,
  ...
}: let
  overlays = jellyfin-overlays.legacyPackages.${pkgs.system};

  jellyPkgs =
    if config.nvidia.enableCUDA
    then overlays.cudaPackages.pkgs
    else overlays;

  jellyWeb = jellyPkgs.jellyfin-web.overrideAttrs (_: o: {
    # TODO: Inject skip intro button for 10.9.0
  });

  jellyfinPkg = jellyPkgs.jellyfin.overrideAttrs (_: o: {
    # This was the only way I found to replace the jellyfin-web package
    preInstall = ''
      makeWrapperArgs+=(
        --add-flags "--ffmpeg ${jellyPkgs.jellyfin-ffmpeg}/bin/ffmpeg"
        --add-flags "--webdir ${jellyWeb}/share/jellyfin-web"
      )
    '';
  });
in {
  services.jellyfin.package = jellyfinPkg;

  environment.systemPackages = [
    jellyfinPkg
    jellyWeb
    jellyPkgs.jellyfin-ffmpeg
  ];
}
