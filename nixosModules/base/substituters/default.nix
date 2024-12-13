{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) elem foldl isList mergeAttrsWithFunc mkIf optionals unique;

  cfg = config.roles.base;

  mergeAttrsList = list:
    foldl (mergeAttrsWithFunc (a: b:
      if isList a && isList b
      then unique (a ++ b)
      else b)) {}
    list;
in
  mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.writeShellApplication {
        name = "rebuild-no-cache";
        runtimeInputs = [config.programs.nh.package];
        text = ''
          exec nh os switch -- --option binary-caches "https://cache.nixos.org" "$@"
        '';
      })
    ];

    nix = {
      settings = let
        mkSubstituterConf = prio: url: key: {
          substituters = ["${url}?priority=${toString prio}"];
          trusted-public-keys = optionals (key != null) [key];
        };
      in
        mergeAttrsList ([
            (mkSubstituterConf 1000 "https://cache.nixos.org" "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=")
            (mkSubstituterConf 1000 "https://hyprland.cachix.org" "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=")
            (mkSubstituterConf 1000 "https://nix-gaming.cachix.org" "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=")
            (mkSubstituterConf 1000 "https://nixpkgs-wayland.cachix.org" "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA=")
            (mkSubstituterConf 1000 "https://nix-community.cachix.org" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=")
            (mkSubstituterConf 1000 "https://viperml.cachix.org" "viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8=")
            (mkSubstituterConf 1000 "https://cuda-maintainers.cachix.org" "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=")
          ]
          ++ optionals (config.networking.hostName != "servivi") [
            (mkSubstituterConf 100 "https://cache.nelim.org" "cache.nelim.org:JmFqkUdH11EA9EZOFAGVHuRYp7EbsdJDHvTQzG2pPyY=")
          ]
          ++ optionals (elem config.networking.hostName ["bbsteamie" "binto" "wim"]) [
            (mkSubstituterConf 10 "https://cache-apt.nelim.org" "cache-apt.nelim.org:NLAsWxa2Qbm4b+hHimjCpZfm48a4oN4O/GPZY9qpjNw=")
          ]);
    };
  }
