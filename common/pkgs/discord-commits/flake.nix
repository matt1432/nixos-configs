{
  inputs.main.url = "path:../../../";

  outputs = {
    self,
    main,
    ...
  }: let
    nixpkgs = main.inputs.nixpkgs;
    supportedSystems = ["x86_64-linux"];

    perSystem = attrs:
      nixpkgs.lib.genAttrs supportedSystems (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        attrs system pkgs);

  in {
    packages = perSystem (system: pkgs: {
      discord-commits = pkgs.callPackage ./nix;
      default = self.packages.${system}.discord-commits;
    });

    formatter = perSystem (_: pkgs: pkgs.alejandra);

    devShells = perSystem (_: pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          alejandra
          git
          nodejs_20
          typescript
        ];
      };
    });
  };
}
