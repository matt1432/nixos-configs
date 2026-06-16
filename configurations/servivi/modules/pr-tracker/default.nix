{
  config,
  pr-tracker,
  ...
}: {
  # When it's not working, check pr-tracker-update for errors
  imports = [pr-tracker.nixosModules.default];

  services.pr-tracker = {
    # FIXME: nixpkgs was taking up 1TB of space somehow
    enable = false;

    userAgent = "matt\'s pr-tracker";
    githubApiTokenFile = config.sops.secrets.pr-tracker.path;
  };
}
