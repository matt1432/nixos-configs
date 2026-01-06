{...}: {
  imports = [./jellyfin-actor-processor.nix];

  services.jellyfin-actor-processor = {
    enable = true;

    jellyfinURL = "https://jelly.nelim.org";
  };
}
