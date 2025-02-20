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

const loader = 'fabric';
const game_version = '1.21.4';

const getVersions = async(slug: string): Promise<ModVersion[]> => {
    const res = await fetch(`https://api.modrinth.com/v2/project/${slug}/version`);

    if (res.ok) {
        return await res.json() as ModVersion[];
    }

    return [];
};

// TODO: prefer version_type 'release'
// TODO: only get latest version based on date_published
const checkModCompat = async(slug: string) => {
    const versions = await getVersions(slug);

    const matching = versions.filter((ver) =>
        ver.game_versions.includes(game_version) &&
        ver.loaders.includes(loader));

    console.log(matching);
};

checkModCompat('lithium');
