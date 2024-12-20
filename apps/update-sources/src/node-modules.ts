import { readPackageJSON, writePackageJSON } from 'pkg-types';
import { readdirSync } from 'node:fs';
import { spawnSync } from 'node:child_process';

import { replaceInFile, npmRun } from './lib';


/* Constants */
const FLAKE = process.env.FLAKE as string;


const updatePackageJson = async(workspaceDir: string, updates: object) => {
    const currentPackageJson = await readPackageJSON(`${workspaceDir}/package.json`);

    const outdated = JSON.parse(npmRun(['outdated', '--json'], workspaceDir));

    const updateDeps = (deps: string) => {
        Object.keys(currentPackageJson[deps]).forEach((dep) => {
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
    npmRun(['install', '--package-lock-only'], workspaceDir);

    return spawnSync(
        'prefetch-npm-deps',
        [`${workspaceDir}/package-lock.json`],
    ).stdout.toString().replace('\n', '');
};


export default async() => {
    const updates = {};

    const packages = readdirSync(FLAKE, { withFileTypes: true, recursive: true });

    for (const path of packages) {
        if (
            path.name === 'package.json' &&
            !path.parentPath.includes('node_modules')
        ) {
            await updatePackageJson(path.parentPath, updates);

            const hash = prefetchNpmDeps(path.parentPath);

            replaceInFile(
                /npmDepsHash = ".*";/,
                `npmDepsHash = "${hash}";`,
                `${path.parentPath}/default.nix`,
            );
        }
    }

    return Object.entries(updates)
        .map(([key, dep]) => `${key}: ${dep}`)
        .join('\n');
};
