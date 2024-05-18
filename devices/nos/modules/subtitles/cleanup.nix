{pkgs, ...}: let
  scriptSrc = pkgs.fetchFromGitHub {
    owner = "brianspilner01";
    repo = "media-server-scripts";
    rev = "00d9efcd37bb2667d23d7747240b59291cde64d3";
    hash = "sha256-Qql6Z+smU8vEJaai0POjdMnYpET9ak4NddNQevEQ8Ds=";
  };

  script = pkgs.concatTextFile {
    name = "sub-clean.sh";
    files = ["${scriptSrc}/sub-clean.sh"];
    executable = true;
  };
in
  pkgs.writeShellApplication {
    name = "sub-clean";

    runtimeInputs = with pkgs; [
      findutils
      gnugrep
      gawk
    ];

    text = ''
      exec ${script} "$@"
    '';
  }
