{
  fetchFromGitHub,
  buildLua,
}:
buildLua {
  pname = "pointer-event";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "christoph-heinrich";
    repo = "mpv-pointer-event";
    rev = "33c5ede5977817596ace5a9942a8c801ad3b3d28";
    hash = "sha256-h2E8wiQX2Vh9qyi2VsXzeOE5vnD9Xin5HZ2Wu2LZUOY=";
  };
}
