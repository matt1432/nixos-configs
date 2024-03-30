import { readdir } from 'fs';
import { ffprobe } from 'fluent-ffmpeg';
import { spawn } from 'child_process';
import { iso6391To3 } from './lang-codes';

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
            const LANG = iso6391To3.get(FILE.split('.').at(-2) ?? 'en') ?? 'eng';

            const OUT_FILE = `${BASE_NAME}.synced.${LANG.substring(0, 2)}.srt`;
            const OUT_PATH = `${DIR}/${OUT_FILE}`;

            if (files.includes(OUT_FILE)) {
                console.warn('Synced subtitles already exist, not doing anything');
                process.exit(0);
            }

            const availLangs = data.streams
                .filter((s) => s.codec_type === 'audio')
                .map((s) => s['tags']['language']);

            const cmd = [
                '--cli sync',
                `--sub-lang ${LANG}`,

                `--ref-stream-by-lang ${availLangs.includes(LANG) ? LANG : availLangs[0]}`,
                '--ref-stream-by-type "audio"',

                `--sub '${FILE}'`,
                `--out '${OUT_PATH}'`,
                // `--out '${OUT_PATH}'`,
                `--ref '${VIDEO}'`,

                // '--overwrite',
            ];

            spawn('subsync', cmd, {
                shell: true,
                stdio: [process.stdin, process.stdout, process.stderr],
            });
        });
    });
};

if (FILE) {
    if (FILE.includes('synced.srt')) {
        console.warn('Won\'t sync already synced subtitles, not doing anything');
        process.exit(0);
    }
    else {
        main();
    }
}
else {
    console.error('Error: no argument passed');
    process.exit(1);
}
