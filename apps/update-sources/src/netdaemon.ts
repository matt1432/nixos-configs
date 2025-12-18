import { spawnSync } from 'node:child_process';
import { writeFileSync } from 'node:fs';
import { styleText } from 'node:util';

/* Constants */
const FLAKE = process.env.FLAKE;

const genVersionFileText = (
    majorVersion: string,
    version: string,
    dotnetVersion: string,
) => `{
  majorVersion = "${majorVersion}";
  version = "${version}";
  dotnetVersion = "${dotnetVersion}";
}
`;

export default (): string | null => {
    console.log(styleText(['magenta'], '\nUpdating NetDaemon:\n'));

    const FOLDER = `${FLAKE}/configurations/homie/modules/home-assistant/netdaemon`;

    const versionFile = JSON.parse(
        spawnSync(
            ['nix', 'eval', '-f', `${FOLDER}/version.nix`, '--json'].join(' '),
            [],
            { shell: true },
        ).stdout.toString(),
    );

    const OLD_VERSION = versionFile.version;

    const VERSION = JSON.parse(
        spawnSync(
            [
                'curl',
                '-s',
                'https://api.github.com/repos/net-daemon/netdaemon/releases/latest',
            ].join(' '),
            [],
            { shell: true },
        ).stdout.toString(),
    ).tag_name.replace('v', '');

    if (OLD_VERSION !== VERSION) {
        writeFileSync(
            `${FOLDER}/version.nix`,
            genVersionFileText(
                versionFile.majorVersion,
                VERSION,
                versionFile.dotnetVersion,
            ),
        );

        spawnSync(
            'sh',
            [
                '-c',
                `
deriv=$(nix build --no-link --print-out-paths --impure --expr "$(cat <<EOF
let
  config = (builtins.getFlake ("$FLAKE")).nixosConfigurations.homie;
  inherit (config) pkgs;
in
  pkgs.callPackage "${FOLDER}/update.nix" {}
EOF
)")
"$deriv/bin/bumpNetdaemonDeps"
            `,
            ],
            {
                cwd: FOLDER,
                stdio: ['inherit', 'ignore', 'inherit'],
            },
        );

        return `NetDaemon: ${OLD_VERSION} -> ${VERSION}\n`;
    }

    return null;
};
