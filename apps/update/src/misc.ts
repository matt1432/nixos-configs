import { readdirSync } from 'node:fs';
import { spawnSync } from 'node:child_process';


/* Constants */
const FLAKE = process.env.FLAKE;

export const updateDocker = () => {
    let updates = '';

    const FILE = `${FLAKE}/devices/nos/modules/arion`;

    readdirSync(FILE, { withFileTypes: true, recursive: true }).forEach((path) => {
        if (path.name === 'compose.nix') {
            updates += spawnSync('updateImages', [path.parentPath], { shell: true })
                .stdout.toString();
        }
    });

    return updates;
};
