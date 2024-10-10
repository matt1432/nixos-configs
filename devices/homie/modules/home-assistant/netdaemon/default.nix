{
  config,
  self,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;

  compiled = pkgs.callPackage ./package.nix {};
in {
  khepri.compositions."netdaemon" = {
    networks.netdaemon = {external = true;};

    services."netdaemon4" = {
      image = import ./images/netdaemon.nix pkgs;
      restart = "always";

      environmentFiles = [secrets.netdaemon.path];
      environment = {
        HomeAssistant__Host = "homie.nelim.org";
        HomeAssistant__Port = "443";
        HomeAssistant__Ssl = "true";
        NetDaemon__ApplicationAssembly = "netdaemon.dll";
        Logging__LogLevel__Default = "Information"; # use Information/Debug/Trace/Warning/Error
        TZ = "America/New_York";
      };

      volumes = ["${compiled.lib}:/data"];
      networks = ["netdaemon"];
    };
  };

  services.home-assistant = {
    customComponents = builtins.attrValues {
      inherit
        (self.legacyPackages.${pkgs.system}.hass-components)
        netdaemon
        ;
    };
  };

  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "updateNuDeps";
      runtimeInputs = with pkgs; [
        dos2unix
        dotnet-sdk_8
      ];
      text = ''
        # Install codegen
        dotnet tool install --create-manifest-if-needed NetDaemon.HassModel.CodeGen --version "$(cat ./.version)"

        # Run it
        dotnet tool run nd-codegen -token "$(sed 's/HomeAssistant__Token=//' ${secrets.netdaemon.path})"
        dos2unix ./HomeAssistantGenerated.cs

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

        $(nix build --no-link --print-out-paths --impure --expr "let self = builtins.getFlake (\"$FLAKE\"); inherit (self.nixosConfigurations.homie) pkgs; in (pkgs.callPackage $FLAKE/devices/homie/modules/home-assistant/netdaemon/package.nix {}).fetch-deps") .
        alejandra .
        rm -r "$FLAKE/.config"

        sed -i "s/finalImageTag = .*/finalImageTag = \"$(cat ./.version)\";/" ./images/netdaemon.nix
        updateImages .
      '';
    })
  ];
}
