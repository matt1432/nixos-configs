{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  ...
}: let
  pname = "jdownloader-cli";
  rev = "0f32237df32dfddc4a577404ba93c7c9d79284c3";
  version = "1.0.2+${builtins.substring 0 7 rev}";
  mainProgram = "jdcli";
in
  buildGoModule {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "matt1432";
      repo = pname;
      inherit rev;
      hash = "sha256-EZyXgd184NjK+eUKB4+Awc+aFrG6goyLfwZ0zVRyGLA=";
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
