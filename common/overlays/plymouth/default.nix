final: prev: {
  plymouth = prev.plymouth.overrideAttrs (o: {
    # https://gitlab.freedesktop.org/plymouth/plymouth/-/issues/236
    version = "unstable-2023-06-17";

    src = prev.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "plymouth";
      repo = "plymouth";
      rev = "b1d5aa9d2a6033bba52cf63643e5878f8a9b68a0";
      hash = "sha256-8DXcwt8CZTni5Ma+I63LzNejlIB0Cr1ATA7Nl3z9z6I=";
    };
  });
}
