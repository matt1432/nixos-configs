import { readdir } from 'fs';

const SUB_EXT_LENGTH = 7;


const FILE = process.argv[2];
const BASE_NAME = FILE.substring(
    FILE.lastIndexOf('/') + 1,
    FILE.length - SUB_EXT_LENGTH,
);

const DIR = FILE.substring(0, FILE.lastIndexOf('/'));

readdir(DIR, (_, files) => {
    const VIDEO = files.filter((f) =>
        f.includes(BASE_NAME) &&
        !f.endsWith('.nfo') &&
        !f.endsWith('.srt'))[0];

    let lang = FILE.split('.').at(-2);

    if (lang === 'fr') {
        lang = 'fre';
    }
    else if (lang === 'en') {
        lang = 'eng';
    }

    const cmd = [
        'subsync --cli sync',
        `--sub-lang ${lang}`,
        `--ref-lang ${lang}`,

        `--sub-file '${FILE}'`,
        `--out-file '${FILE}'`,
        `--ref-file '${VIDEO}'`,

        '--overwrite',
    ];

    console.log(cmd);
});
