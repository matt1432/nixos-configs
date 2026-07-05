# NOTE: remove this when https://github.com/jellyfin/jellyfin/pull/16668 reaches a release
{...}: {
  imports = [./jellyfin-actor-processor.nix];

  services.jellyfin-actor-processor = {
    enable = true;

    jellyfinURL = "https://jelly.nelim.org";
  };
}
