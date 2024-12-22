{
  mkShell,
  gcc,
  clang-tools,
  cmake-language-server,
  ...
}:
mkShell {
  packages = [
    gcc
    clang-tools
    cmake-language-server
  ];
}
