{
  # nix build inputs
  writeShellApplication,
  # deps
  alejandra,
  dos2unix,
  dotnetCorePackages,
  findutils,
  gnused,
  nix,
  ...
}: let
  versionFile = import ./version.nix;
  version = versionFile.version;
  dotnetVersion = builtins.replaceStrings ["."] ["_"] versionFile.dotnetVersion;

  nixFetchDeps =
    #nix
    ''
      let
        config = (builtins.getFlake ("$FLAKE")).nixosConfigurations.homie;
        inherit (config) pkgs;

        netdaemonConfig = pkgs.callPackage "$FLAKE/configurations/homie/modules/home-assistant/netdaemon/package.nix" {};
      in
        netdaemonConfig.fetch-deps
    '';
in
  writeShellApplication {
    name = "bumpNetdaemonDeps";

    runtimeInputs = [
      alejandra
      dos2unix
      dotnetCorePackages."sdk_${dotnetVersion}"
      findutils
      gnused
      nix
    ];

    text = ''
      echo -n ${version} > .version
      echo -n net${versionFile.dotnetVersion} > .dotnetversion

      # Install codegen
      dotnet tool install --create-manifest-if-needed NetDaemon.HassModel.CodeGen --version "${version}"

      # Run it
      dotnet tool run nd-codegen -token "$(sed 's/HomeAssistant__Token=//' /run/secrets/netdaemon)" || true
      dos2unix ./HomeAssistantGenerated.cs || true

      # This is to not have it count towards CSharp in the repo
      mv ./HomeAssistantGenerated.cs ./HomeAssistantGenerated || true

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
      )") ./deps.json

      sed -i "s/finalImageTag = .*/finalImageTag = \"${version}\";/" ./images/netdaemon.nix
      updateImages .

      alejandra -q .
      rm -r "$FLAKE/.config"
      rm -r "$FLAKE/dotnet-tools.json"
    '';
  }
