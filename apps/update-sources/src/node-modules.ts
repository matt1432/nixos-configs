import { readPackageJSON } from 'pkg-types';
import { readdirSync } from 'node:fs';
import { spawnSync } from 'node:child_process';


/* Constants */
const FLAKE = process.env.FLAKE as string;

export default () => {
    readdirSync(FLAKE, { withFileTypes: true, recursive: true }).forEach(async(path) => {
        if (path.name === 'package.json' && !path.parentPath.includes('node_modules')) {
            const currentWorkspace = path.parentPath;

            const currentPackageJson = await readPackageJSON(`${currentWorkspace}/package.json`);
            const outdated = JSON.parse(spawnSync(
                'npm',
                ['outdated', '--json'],
                { cwd: currentWorkspace },
            ).stdout.toString());

            Object.keys(currentPackageJson.dependencies ?? {}).forEach((dep) => {
                const versions = outdated[dep];

                if (!versions?.current) {
                    return;
                }

                console.log(`${dep}: ${versions.current} -> ${versions.latest}`);
            });

            Object.keys(currentPackageJson.devDependencies ?? {}).forEach((dep) => {
                const versions = outdated[dep];

                if (!versions?.current) {
                    return;
                }

                console.log(`${dep}: ${versions.current} -> ${versions.latest}`);
            });
        }
    });
};
