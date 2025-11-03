self: final: prev: let
  inherit (self.inputs) quickshell;

  overrideAll = self.lib.overrideAll final;
in {
  quickshell = overrideAll quickshell.packages.${final.stdenv.hostPlatform.system}.default {
    gitRev = quickshell.rev;

    stdenv = final.clangStdenv;

    debug = false;
    withI3 = false;
    withX11 = false;
  };
}
