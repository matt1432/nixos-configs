import { readPackageJSON, writePackageJSON } from 'pkg-types';
import { accessSync, constants, existsSync } from 'node:fs';
import { spawnSync } from 'node:child_process';

import { replaceInFile, npmRun } from './lib';


/* Constants */
const FLAKE = process.env.FLAKE as string;

const PINS = new Map([]);


const updatePackageJson = async(workspaceDir: string, updates: object) => {
    const currentPackageJson = await readPackageJSON(`${workspaceDir}/package.json`);

    const outdated = JSON.parse(npmRun(['outdated', '--json'], workspaceDir));

    const updateDeps = (deps: string) => {
        Object.keys(currentPackageJson[deps]).forEach((dep) => {
            if (PINS.has(dep)) {
                currentPackageJson[deps][dep] = PINS.get(dep);

                return;
            }

            const versions = outdated[dep];
            const current = versions?.wanted || versions?.current;

            if (!current) {
                return;
            }

            if (current !== versions.latest) {
                updates[dep] = `${current} -> ${versions.latest}`;
            }

            currentPackageJson[deps][dep] = versions.latest;
        });
    };

    if (currentPackageJson.dependencies) {
        updateDeps('dependencies');
    }

    if (currentPackageJson.devDependencies) {
        updateDeps('devDependencies');
    }

    await writePackageJSON(`${workspaceDir}/package.json`, currentPackageJson);
};


const prefetchNpmDeps = (workspaceDir: string): string => {
    npmRun(['update', '--package-lock-only'], workspaceDir);

    return spawnSync(
        'prefetch-npm-deps',
        [`${workspaceDir}/package-lock.json`],
    ).stdout.toString().replace('\n', '');
};


export default async() => {
    console.log('Updating node modules');

    const updates = {};

    const packages = spawnSync('find', [FLAKE, '-name', 'package.json']).stdout.toString().split('\n')
        .filter((f) => f !== '')
        .filter((f) => ![
            '.direnv',
            'node_modules',
            'results',
        ].some((dirName) => f.includes(dirName)));

    for (const path of packages) {
        console.log(path);

        try {
            accessSync(path, constants.R_OK | constants.W_OK);

            const parentPath = path.replace('/package.json', '');

            await updatePackageJson(parentPath, updates);

            if (existsSync(`${parentPath}/default.nix`)) {
                const hash = prefetchNpmDeps(parentPath);

                replaceInFile(
                    /npmDepsHash = ".*";/,
                    `npmDepsHash = "${hash}";`,
                    `${parentPath}/default.nix`,
                );
            }

            // Make sure we update the apps' config package-lock.json
            if (parentPath.includes('apps/config')) {
                npmRun(['i'], parentPath);
            }
        }
        catch (e) {
            console.warn(`Could not write to ${path}`);
            console.warn(e);
        }
    }

    return Object.entries(updates)
        .map(([key, dep]) => `${key}: ${dep}`)
        .join('\n');
};
