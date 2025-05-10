{
  # nix build inputs
  writeShellApplication,
  # deps
  alejandra,
  dos2unix,
  dotnet-sdk_9,
  findutils,
  gnused,
  nix,
  ...
}: let
  nixFetchDeps =
    #nix
    ''
      let
        config = (builtins.getFlake ("$FLAKE")).nixosConfigurations.homie;
        inherit (config) pkgs;

        netdaemonConfig = pkgs.callPackage ${toString ./package.nix} {};
      in
        netdaemonConfig.fetch-deps
    '';
in
  writeShellApplication {
    name = "bumpNetdaemonDeps";

    runtimeInputs = [
      alejandra
      dos2unix
      dotnet-sdk_9
      findutils
      gnused
      nix
    ];

    text = ''
      # Install codegen
      dotnet tool install --create-manifest-if-needed NetDaemon.HassModel.CodeGen --version "$(cat ./.version)"

      # Run it
      dotnet tool run nd-codegen -token "$(sed 's/HomeAssistant__Token=//' /run/secrets/netdaemon)"
      dos2unix ./HomeAssistantGenerated.cs

      # This is to not have it count towards CSharp in the repo
      mv ./HomeAssistantGenerated.cs ./HomeAssistantGenerated

      # Update all nugets to latest versions
      regex='PackageReference Include="([^"]*)" Version="([^"]*)"'

      find . -type f -name '*.csproj' | while read -r file; do
          # Extract unique package names from the .csproj file
          packages=$(grep -oP "$regex" "$file" | sed -E 's/.*Include="([^"]*)".*/\1/' | sort -u)

          # Loop through each package and update
          for package in $packages; do
              echo -e "\033[35mUpdate $file package: $package\033[0m"
              dotnet add "$file" package "$package"
          done
      done

      $(nix build --no-link --print-out-paths --impure --expr "$(cat <<EOF
      ${nixFetchDeps}
      EOF
      )") .

      alejandra -q .
      rm -r "$FLAKE/.config"

      sed -i "s/finalImageTag = .*/finalImageTag = \"$(cat ./.version)\";/" ./images/netdaemon.nix
      updateImages .
    '';
  }
