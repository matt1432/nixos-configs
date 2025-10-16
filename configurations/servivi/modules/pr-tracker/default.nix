{
  config,
  pr-tracker,
  ...
}: {
  # When it's not working, check pr-tracker-update for errors
  imports = [pr-tracker.nixosModules.default];

  services.pr-tracker = {
    enable = true;

    userAgent = "matt\'s pr-tracker";
    githubApiTokenFile = config.sops.secrets.pr-tracker.path;
  };
}
