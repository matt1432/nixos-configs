self: final: prev: let
  inherit (self.inputs) quickshell;

  overrideAll = self.lib.overrideAll final;
in {
  quickshell = overrideAll quickshell.packages.${final.system}.default {
    gitRev = quickshell.rev;

    buildStdenv = final.clangStdenv;

    debug = false;
    withI3 = false;
    withX11 = false;
  };
}
