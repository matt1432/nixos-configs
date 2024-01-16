{
  stdenvNoCC,
  jre,
  fetchFromGitHub,
  fetchurl,
  makeWrapper,
  makeDesktopItem,
  rsync,
  ...
}:
stdenvNoCC.mkDerivation rec {
  name = "rars-flatlaf";

  src = fetchFromGitHub {
    owner = "privat";
    repo = "rars";
    rev = "fd34014efd65b3cb5a52f1729c3b8240cae0c332";
    hash = "sha256-D8X/cr+fnq/OOFYfMG9aPss95J8Z2yiROuF9kmHkK40=";
    fetchSubmodules = true;
  };

  desktopItem = makeDesktopItem {
    name = "RARS";
    desktopName = "RARS";
    exec = name;
    icon = name;
  };

  nativeBuildInputs = [makeWrapper rsync jre];

  installPhase = let
    flatlaf = fetchurl {
      url = "https://repo1.maven.org/maven2/com/formdev/flatlaf/3.2/flatlaf-3.2.jar";
      hash = "sha256-HAG+G9undDXWtySokKl7lkIUCFI7lEBduu+UgSVaxAA=";
    };
    icon = fetchurl {
      url = "https://riscv.or.jp/wp-content/uploads/2019/06/cropped-RISC-V-logo-figonly-mod-2.png";
      hash = "sha256-e1/iVmadVzyO77ikBr1cdXsJdDj8TiXh3Oyjek9GwqM=";
    };
  in
    /*
    bash
    */
    ''
      # ./build-jar.sh
      mkdir -p build
      find src -name "*.java" | xargs javac --release 8 -d build
      if [[ "$OSTYPE" == "darwin"* ]]; then
          find src -type f -not -name "*.java" -exec rsync -R {} build \;
      else
          find src -type f -not -name "*.java" -exec cp --parents {} build \;
      fi
      cp -rf build/src/* build
      rm -r build/src
      cp README.md License.txt build
      cd build
      jar cfm ../rars.jar ./META-INF/MANIFEST.MF *
      chmod +x ../rars.jar

      cd ..

      # ./build-jar-flatlaf.sh
      mkdir -p build-flatlaf/
      cd build-flatlaf/

      cp ${flatlaf} ../flatlaf.jar

      jar x < ../rars.jar
      jar x < "../flatlaf.jar"

      cat > META-INF/MANIFEST.MF <<EOF
      Manifest-Version: 1.0
      Implementation-Version: 3.1.1
      Multi-Release: true
      Main-Class: rars.Launch
      EOF

      jar cfm ../rars-flatlaf.jar META-INF/MANIFEST.MF *
      chmod +x ../rars-flatlaf.jar

      cd ..

      # InstallPhase
      runHook preInstall

      cat > ./rars.desktop <<EOF
      EOF

      mkdir -p "$out/share/pixmaps"
      cp "${icon}" "$out/share/pixmaps/${name}.png"
      install -D $desktopItem/share/applications/* $out/share/applications/rars.desktop

      export JAR=$out/share/java/${name}/${name}.jar
      install -D ./${name}.jar $JAR
      makeWrapper ${jre}/bin/java $out/bin/${name} \
        --add-flags "-jar $JAR"

      runHook postInstall
    '';
}
