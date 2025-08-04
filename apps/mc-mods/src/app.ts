import { createWriteStream, mkdirSync, rmSync } from 'fs';
import { Readable } from 'stream';
import { styleText } from 'node:util';

interface Hashes {
    sha1: string
    sha512: string
}
interface File {
    hashes: Hashes
    url: string
    filename: string
    primary: boolean
    size: number
    file_type: string
}
interface Dependency {
    version_id: string
    project_id: string
    file_name: string
    dependency_type: string
}
interface ModVersion {
    game_versions: string[]
    loaders: string[]
    id: string
    project_id: string
    author_id: string
    featured: boolean
    name: string
    version_number: string
    changelog: string
    changelog_url: string
    date_published: string
    downloads: number
    version_type: string
    status: string
    files: File[]
    dependencies: Dependency[]
}

const LOADER = 'fabric';

const game_version = process.argv[2] ?? '';
const action = process.argv[3] ?? 'check';

const getVersions = async(slug: string): Promise<ModVersion[]> => {
    const res = await fetch(`https://api.modrinth.com/v2/project/${slug}/version`);

    return res.ok ?
        await res.json() as ModVersion[] :
        [];
};

const checkModCompat = async(slug: string): Promise<ModVersion | null> => {
    const versions = await getVersions(slug);

    const matching = versions.filter((ver) =>
        ver.game_versions.includes(game_version) &&
        ver.loaders.includes(LOADER));

    if (matching.length === 0) {
        return null;
    }

    const timeSorted = matching.sort((a, b) => {
        const dateA = new Date(a.date_published);
        const dateB = new Date(b.date_published);

        return dateB.getTime() - dateA.getTime();
    });

    return timeSorted.some((v) => v.version_type === 'release') ?
        timeSorted.filter((v) => v.version_type === 'release')[0] :
        timeSorted[0];
};

const getDownloadUrls = (version: ModVersion): string[] => version.files.map((file) => file.url);

const showModDownloadUrls = async(modName: string): Promise<boolean> => {
    const ver = await checkModCompat(modName);

    if (ver) {
        const urls = getDownloadUrls(ver);

        console.log(`\n${modName}:`, urls);

        return true;
    }
    else {
        return false;
    }
};

const download = async(url: string, path: string) => Readable
    .fromWeb((await fetch(url)).body!).pipe(createWriteStream(path));

const main = () => {
    const mods = [
        'badpackets',
        'c2me-fabric',
        'cloth-config',
        'clumps',
        'fabric-api',
        'ferrite-core',
        'leaves-be-gone',
        'lithium',
        'modernfix',
        'no-chat-reports',
        'noisium',
        'vmp-fabric',
        'wthit',
    ];

    if (action === 'check') {
        mods.forEach(async(modName) => {
            if (!(await showModDownloadUrls(modName))) {
                console.error(
                    styleText(
                        ['red'],
                        `\nNo matching releases of ${modName} were found for ${game_version}`,
                    ),
                );
            }
        });
    }
    else if (action === 'download') {
        rmSync('./out', { force: true, recursive: true });
        mkdirSync('./out');

        mods.forEach(async(modName) => {
            const ver = await checkModCompat(modName);

            if (ver === null) {
                console.error(`No matching releases of ${modName} were found for ${game_version}`);

                return;
            }

            const fileName =
                `${modName}-${ver.version_number}.jar`;

            console.log(`Downloading ${fileName}`);

            await download(
                ver.files[0].url,
                `./out/${fileName}`,
            );
        });
    }
};

main();
