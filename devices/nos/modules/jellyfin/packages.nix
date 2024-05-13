{
  config,
  jellyfin-flake,
  pkgs,
  ...
}: let
  jellyPkgs =
    if config.nvidia.enableCUDA
    then jellyfin-flake.packages.${pkgs.system}.cudaPackages // {inherit (pkgs.cudaPackages.pkgs) jellyfin-ffmpeg;}
    else jellyfin-flake.packages.${pkgs.system} // {inherit (pkgs) jellyfin-ffmpeg;};

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
