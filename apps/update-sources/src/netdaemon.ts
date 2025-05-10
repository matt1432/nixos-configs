import { readFileSync, writeFileSync } from 'node:fs';
import { spawnSync } from 'node:child_process';
import { styleText } from 'node:util';


/* Constants */
const FLAKE = process.env.FLAKE;

export default (): string | null => {
    console.log(styleText(['magenta'], '\nUpdating NetDaemon:\n'));

    const FOLDER = `${FLAKE}/configurations/homie/modules/home-assistant/netdaemon`;

    const OLD_VERSION = readFileSync(`${FOLDER}/.version`).toString().replace('\n', '');

    const VERSION = JSON.parse(spawnSync('curl',
        ['-s', 'https://api.github.com/repos/net-daemon/netdaemon/releases/latest'],
        { shell: true }).stdout.toString()).tag_name.replace('v', '');

    if (OLD_VERSION !== VERSION) {
        writeFileSync(`${FOLDER}/.version`, `${VERSION}\n`);

        spawnSync('bumpNetdaemonDeps', [], {
            cwd: FOLDER,
            stdio: 'inherit',
        });

        return `NetDaemon: ${OLD_VERSION} -> ${VERSION}\n`;
    }

    return null;
};
