import { readdir } from 'fs';
import { ffprobe } from 'fluent-ffmpeg';
import { exec } from 'child_process';

const SUB_EXT_LENGTH = 7;


const FILE = process.argv[2];

const main = () => {
    const BASE_NAME = FILE.substring(
        FILE.lastIndexOf('/') + 1,
        FILE.length - SUB_EXT_LENGTH,
    );

    const DIR = FILE.substring(0, FILE.lastIndexOf('/'));

    readdir(DIR, (_, files) => {
        const VIDEO = `${DIR}/${files.filter((f) =>
            f.includes(BASE_NAME) &&
            !f.endsWith('.nfo') &&
            !f.endsWith('.srt'))[0]}`;

        ffprobe(VIDEO, (_e, data) => {
            const other = (lang: string) => lang === 'fre' ? 'eng' : 'fre';

            let lang = FILE.split('.').at(-2) ?? 'en';

            if (lang === 'fr') {
                lang = 'fre';
            }
            else if (lang === 'en') {
                lang = 'eng';
            }

            const availLangs = data.streams
                .filter((s) => s.codec_type === 'audio')
                .map((s) => s['tags']['language']);

            const cmd = [
                'subsync --cli sync',
                `--sub-lang ${lang}`,

                `--ref-stream-by-lang ${availLangs.includes(lang) ? lang : other(lang)}`,
                '--ref-stream-by-type "audio"',

                `--sub '${FILE}'`,
                `--out '${DIR}/${BASE_NAME}.synced.${lang.substring(0, 2)}.srt'`,
                // `--out '${FILE}'`,
                `--ref '${VIDEO}'`,

                // '--overwrite',
            ].join(' ');

            exec(cmd, (error, stdout, stderr) => {
                console.log(error);
                console.log(stdout);
                console.log(stderr);
            });
        });
    });
};

if (FILE) {
    main();
}
else {
    console.error('Error: no argument passed');
    process.exit(1);
}
