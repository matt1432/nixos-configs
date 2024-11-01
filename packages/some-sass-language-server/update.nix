#bash
''
  cd "$FLAKE/packages/some-sass-language-server" || return

  latest=$(npm outdated --json | jq -r '.["some-sass-language-server"]["latest"]' || true)

  if [[ "$latest" != "null" ]]; then
      sed -i "s#\"some-sass-language-server\": \"[^\"]*\"#\"some-sass-language-server\": \"$latest\"#" ./package.json

      npm update

      npm_hash="$(prefetch-npm-deps ./package-lock.json)"

      sed -i "s#npmDepsHash = .*#npmDepsHash = \"$npm_hash\";#" ./default.nix
  fi
''
