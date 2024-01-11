{
  inputs.main.url = "path:../../../../.";

  outputs = {
    self,
    main,
  }: let
    inherit (main.inputs) nixpkgs;
    supportedSystems = ["x86_64-linux"];

    perSystem = attrs:
      nixpkgs.lib.genAttrs supportedSystems (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        attrs system pkgs);
  in {
    devShells = perSystem (_: pkgs: {
      default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          nix
          git
          alejandra
          typescript
          bun
          nodejs_18
        ];
      };
    });

    formatter = perSystem (_: pkgs: pkgs.alejandra);
  };
}
