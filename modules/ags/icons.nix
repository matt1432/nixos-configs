{
  agsConfigDir,
  pkgs,
  ...
}: {
  "${agsConfigDir}/config/icons/down-large-symbolic.svg".source = pkgs.fetchurl {
    url = "https://www.svgrepo.com/download/158537/down-chevron.svg";
    hash = "sha256-mOfNjgZh0rt6XosKA2kpLY22lJldSS1XCphgrnvZH1s=";
  };

  "${agsConfigDir}/config/icons/nixos-logo-symbolic.svg".text =
    # xml
    ''
      <svg viewBox="0 0 24 24" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
        <defs>
          <path id="lambda" d="M7.352 1.592l-1.364.002L5.32 2.75l1.557 2.713-3.137-.008-1.32 2.34H14.11l-1.353-2.332-3.192-.006-2.214-3.865z" fill="#000000" />
        </defs>
        <use xlink:href="#lambda" />
        <use xlink:href="#lambda" transform="rotate(120 12 12)" />
        <use xlink:href="#lambda" transform="rotate(240 12 12)" />
        <g opacity=".7">
          <use xlink:href="#lambda" transform="rotate(60 12 12)" />
          <use xlink:href="#lambda" transform="rotate(180 12 12)" />
          <use xlink:href="#lambda" transform="rotate(300 12 12)" />
        </g>
      </svg>
    '';
}
