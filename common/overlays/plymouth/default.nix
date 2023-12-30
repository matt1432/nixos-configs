final: prev: {
  plymouth = prev.plymouth.overrideAttrs (o: {
    version = "unstable-2023-12-08";

    src = prev.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "plymouth";
      repo = "plymouth";

      # https://gitlab.freedesktop.org/plymouth/plymouth/-/issues/236
      # Last commit that works
      rev = "58cc9f84e456ab0510b13d7bdbc13697467ca7be";
      hash = "sha256-hgQ8nCphR4hc+WTNtS8GgBrC54uYnvTCp7kjgB/u5lE=";
    };
  });
}
