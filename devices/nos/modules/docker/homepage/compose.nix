{
  config,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;
  inherit (pkgs.writers) writeYAML;
in {
  khepri.compositions."homepage".services."homepage" = {
    image = import ./images/homepage.nix pkgs;
    restart = "always";

    ports = [
      "3020:3000"
    ];

    extraHosts = ["lan.nelim.org=10.0.0.130"];

    environmentFiles = [secrets.homepage.path];

    volumes = let
      services = writeYAML "services.yaml" (import ./services.nix);

      bookmarks = writeYAML "bookmarks.yaml" {};

      settings = writeYAML "settings.yaml" {
        # FIXME: title not working
        title = "bruh";
        theme = "dark";
        color = "gray";
        target = "_self";

        layout.video = {
          style = "columns";
          row = 4;
          # columns = 2;
        };
      };

      widgets = writeYAML "widgets.yaml" [
        {
          resources = {
            cpu = true;
            memory = true;
            disk = "/";
          };
        }
        {
          search = {
            provider = "duckduckgo";
            target = "_blank";
          };
        }
      ];
    in [
      "${bookmarks}:/app/config/bookmarks.yaml:ro"
      "${services}:/app/config/services.yaml:ro"
      "${settings}:/app/config/settings.yaml:ro"
      "${widgets}:/app/config/widgets.yaml:ro"
    ];
  };
}
