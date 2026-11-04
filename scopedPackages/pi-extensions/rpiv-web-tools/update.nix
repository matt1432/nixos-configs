#bash
''
  cd "$FLAKE/scopedPackages/pi-extensions/rpiv-web-tools" || return

  latest=$(npm outdated --json | jq -r '.["@juicesharp/rpiv-web-tools"]["latest"]' || true)

  if [[ "$latest" != "null" ]]; then
      sed -i "s#\"@juicesharp/rpiv-web-tools\": \"[^\"]*\"#\"@juicesharp/rpiv-web-tools\": \"$latest\"#" ./package.json

      npm update

      npm_hash="$(prefetch-npm-deps ./package-lock.json)"

      sed -i "s#npmDepsHash = .*#npmDepsHash = \"$npm_hash\";#" ./default.nix
  fi
''
