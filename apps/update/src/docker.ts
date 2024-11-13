import { readdirSync } from 'node:fs';
import { spawnSync } from 'node:child_process';


/* Constants */
const FLAKE = process.env.FLAKE;

const updateImages = (imagePath: string): string | undefined => {
    console.log(`Updating ${imagePath.split('/').at(-1)} images`);

    const out = spawnSync('updateImages', [imagePath], { shell: true }).stdout.toString();

    if (!out.startsWith('# Locked')) {
        return out;
    }
};

export const updateDocker = () => {
    let updates = '';

    updates += updateImages(`${FLAKE}/devices/nos/modules/jellyfin`) ?? '';
    updates += updateImages(`${FLAKE}/devices/homie/modules/home-assistant/netdaemon`) ?? '';

    const DIR = `${FLAKE}/devices/nos/modules/docker`;

    readdirSync(DIR, { withFileTypes: true, recursive: true }).forEach((path) => {
        if (path.name === 'compose.nix') {
            updates += updateImages(path.parentPath) ?? '';
        }
    });

    return updates;
};
