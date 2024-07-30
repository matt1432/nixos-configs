{
  config,
  pr-tracker,
  ...
}: {
  imports = [pr-tracker.nixosModules.default];

  services.pr-tracker = {
    enable = true;

    userAgent = "matt\'s pr-tracker";
    githubApiTokenFile = config.sops.secrets.pr-tracker.path;
  };
}
