import { readdirSync } from 'node:fs';
import { spawnSync } from 'node:child_process';
import { styleText } from 'node:util';


/* Constants */
const FLAKE = process.env.FLAKE;

const updateImages = (imagePath: string): string | undefined => {
    console.log(`Updating ${imagePath.split('/').at(-1)} images`);

    const out = spawnSync('updateImages', [imagePath], { shell: true }).stdout.toString();

    if (!out.startsWith('# Locked')) {
        return out;
    }
};

export default () => {
    console.log(styleText(['magenta'], '\nUpdating docker images:\n'));

    let updates = '';

    updates += updateImages(`${FLAKE}/configurations/nos/modules/jellyfin`) ?? '';
    updates += updateImages(`${FLAKE}/configurations/homie/modules/home-assistant/netdaemon`) ?? '';

    const DIR = `${FLAKE}/configurations/nos/modules/docker`;

    readdirSync(DIR, { withFileTypes: true, recursive: true }).forEach((path) => {
        if (path.name === 'compose.nix') {
            updates += updateImages(path.parentPath) ?? '';
        }
    });

    return updates;
};
