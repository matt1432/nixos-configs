{
  fetchFromGitHub,
  buildLua,
}:
buildLua {
  pname = "persist-properties";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "d87";
    repo = "mpv-persist-properties";
    rev = "ddb1e6bd7a7d57da9b567ea8dc5227906f416ec6";
    hash = "sha256-C2nejhkxAZgfKRl9FrZZqODq2xW6zCbv/sBiqXSAd2k=";
  };
}
