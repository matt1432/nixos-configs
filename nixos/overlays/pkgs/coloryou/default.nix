# https://blog.hackeriet.no/packaging-python-script-for-nixos/

# Below, we can supply defaults for the function arguments to make the script
# runnable with `nix-build` without having to supply arguments manually.
# Also, this lets me build with Python 3.11 by default, but makes it easy
# to change the python version for customised builds (e.g. testing).
{ nixpkgs ? import <nixpkgs> {}, pythonPkgs ? nixpkgs.pkgs.python311Packages }:

let
  # This takes all Nix packages into this scope
  inherit (nixpkgs) pkgs;
  # This takes all Python packages from the selected version into this scope.
  inherit pythonPkgs;

  # Inject dependencies into the build function
  f = { buildPythonPackage, utils, material-color-utilities }:
    buildPythonPackage rec {
      pname = "coloryou";
      version = "0.0.2";

      # If you have your sources locally, you can specify a path
      src = ./.;

      # Pull source from a Git server.
      #src = builtins.fetchGit {
        #url = "git://github.com/stigok/ruterstop.git";
        #ref = "master";
        #rev = "a9a4cd60e609ed3471b4b8fac8958d009053260d";
      #};

      # Specify runtime dependencies for the package
      propagatedBuildInputs = [ utils material-color-utilities ];

      postInstall = ''
        mv -v $out/bin/coloryou.py $out/bin/coloryou
      '';

      meta = {
        description = ''
          Get Material You colors from an image.
        '';
      };
    };

  drv = pythonPkgs.callPackage f {};
in
  if pkgs.lib.inNixShell then drv.env else drv

