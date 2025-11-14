{
  nix-prefetch-docker,
  skopeo,
  writeShellApplication,
  ...
}:
writeShellApplication {
  name = "updateImages";

  runtimeInputs = [
    (writeShellApplication {
      name = "pullImage";
      runtimeInputs = [nix-prefetch-docker skopeo];
      text = ''
        FILE="$1"

        if ! grep "Locked" "$FILE" &> /dev/null; then
            IMAGE=$(sed -n 's/.*imageName = "\([^"]*\).*/\1/p' "$FILE")
            TAG=$(sed -n 's/.*finalImageTag = "\([^"]*\).*/\1/p' "$FILE")
            CURRENT_DIGEST=$(sed -n 's/.*imageDigest = "\([^"]*\).*/\1/p' "$FILE")
            NEW_DIGEST=$(skopeo inspect "docker://$IMAGE:$TAG" --no-tags | jq '.Digest' -r)

            output="$IMAGE $TAG"

            if [[ "$CURRENT_DIGEST" != "$NEW_DIGEST" ]]; then
                echo -e "• $output:\n   $CURRENT_DIGEST\n → $NEW_DIGEST\n"

                has_file=false

                for file in /nix/store/*"''${IMAGE//\//-}-$TAG".tar.drv; do
                    file_digest="$(nix derivation show "$file" | jq -r '.[].env.imageDigest')"

                    if [[ "$file_digest" = "$NEW_DIGEST" ]]; then
                        out_file="$(nix derivation show "$file" | jq -r '.[].env.out')"

                        HASH=$(nix-hash --flat --type sha256 --sri "$out_file")

                        has_file=true
                        break
                    fi
                done

                if [[ "$has_file" != true ]]; then
                    HASH=$(nix-prefetch-docker "$IMAGE" "$TAG" --image-digest "$NEW_DIGEST" --json | jq -r '.hash')
                fi

                sed -i "s#imageDigest.*#imageDigest = \"''${NEW_DIGEST//#/\\#}\";#" "$FILE"
                sed -i "s#hash.*#hash = \"''${HASH//#/\\#}\";#" "$FILE"
            fi
        fi
      '';
    })
  ];

  text = ''
    DIR=''${1:-"."}
    find "$DIR"/images -type f -exec pullImage {} \;
  '';
}
