{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  ...
}: let
  pname = "jdownloader-cli";
  version = "1.0.3";
  mainProgram = "jdcli";
in
  buildGoModule {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "rkosegi";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-/qGV+v+Id5C7kTlvcolQmhRf6oHRHBoVXyd5YX0pxhE=";
    };

    vendorHash = "sha256-lBxddgaW1s3xjGODZhlvYBmK1vC+IdmpztTgagOy7J4=";

    nativeBuildInputs = [
      installShellFiles
    ];

    postInstall = ''
      mv $out/bin/cmd $out/bin/${mainProgram}

      for shell in bash fish zsh; do
          $out/bin/${mainProgram} completion $shell > ${mainProgram}.$shell
          installShellCompletion ${mainProgram}.$shell
      done
    '';

    meta = {
      inherit mainProgram;
      license = lib.licenses.asl20;
      homepage = "https://github.com/rkosegi/jdownloader-cli";
      description = ''
        Command line interface to JDownloader based on jdownloader-go library.
      '';
    };
  }
