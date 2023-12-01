{nix-index-db, ...}: {
  imports = [nix-index-db.hmModules.nix-index];

  programs = {
    nix-index-database.comma.enable = true;
    nix-index = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
