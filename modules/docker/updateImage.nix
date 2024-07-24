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

        IMAGE=$(sed -n 's/.*imageName = "\([^"]*\).*/\1/p' "$FILE")
        TAG=$(sed -n 's/.*finalImageTag = "\([^"]*\).*/\1/p' "$FILE")
        CURRENT_DIGEST=$(sed -n 's/.*imageDigest = "\([^"]*\).*/\1/p' "$FILE")
        NEW_DIGEST=$(skopeo inspect "docker://$IMAGE:$TAG" | jq '.Digest' -r)

        output="$IMAGE $TAG"

        if ! grep "Locked" "$FILE"; then
            if [[ "$CURRENT_DIGEST" != "$NEW_DIGEST" ]]; then
                echo -e "• $output:\n   $CURRENT_DIGEST\n → $NEW_DIGEST\n"
                PREFETCH=$(nix-prefetch-docker "$IMAGE" "$TAG")
                echo -e "pkgs:\npkgs.dockerTools.pullImage $PREFETCH" > "$FILE"
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
