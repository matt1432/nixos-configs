import {
    mkdir,
    readdir as readDir,
    rename as mv,
} from 'fs/promises';

import { ffprobe as ffProbe } from 'fluent-ffmpeg';
import { spawn } from 'child_process';

import { ISO6391To3, ISO6393To1 } from './lang-codes';


/**
 * These are the cli arguments
 *
 * @param directory the directory in which we want to sync the subtitles
 * @param languages a comma-separated list of languages (3 letters) to sync the subtitles
 */
const DIR = process.argv[2];
let langs = process.argv[3].split(',');


// Check if there are 2 params
if (DIR && langs) {
    main();
}
else {
    console.error('Error: no argument passed');
    process.exit(1);
}

function getVideoPath(files: string[]) {
    const fileName = DIR.split('/').at(-1) ?? '';

    return `${DIR}/${files.filter((f) =>
        f.includes(fileName) &&
        !f.endsWith('.nfo') &&
        !f.endsWith('.srt'))[0]}`;
}

function runSubSync(cmd: string[]) {
    spawn('subsync', cmd, {
        shell: true,
        stdio: [process.stdin, process.stdout, process.stderr],
    });
}

async function main() {
    const files = await readDir(DIR);

    const VIDEO = getVideoPath(files);
    const BASE_NAME = VIDEO.split('/').at(-1)?.replace(/\.[^.]*$/, '');

    // Check if backup folder already exists and create it if not
    if (!files.some((f) => f.endsWith('.srt.bak'))) {
        await mkdir(`${DIR}/.srt.bak`);
    }
    else {
        const backups = await readDir(`${DIR}/.srt.bak`);

        // Remove synced subtitles from the list to sync
        // langs - backups
        langs = langs.filter((n) => !backups
            .some((s) => n === ISO6391To3.get(s.split('.').at(-2) ?? '')));
    }

    if (langs.length === 0) {
        console.warn('Subtitles have already been synced');
        process.exit(0);
    }

    // ffprobe the video file to see available audio tracks
    ffProbe(VIDEO, (_e, data) => {
        const AVAIL_LANGS = data.streams
            .filter((s) => s.codec_type === 'audio')
            .map((s) => s['tags']['language']);

        // Sync subtitles one by one
        langs.forEach(async(lang) => {
            const FILE_NAME = `${BASE_NAME}.${ISO6393To1.get(lang)}.srt`;
            const IN_FILE = `${DIR}/.srt.bak/${FILE_NAME}`;
            const OUT_FILE = `${DIR}/${FILE_NAME}`;

            const cmd = [
                '--cli sync',
                `--sub-lang ${lang}`,

                `--ref-stream-by-lang ${AVAIL_LANGS.includes(lang) ?
                    lang :
                    AVAIL_LANGS[0]}`,
                '--ref-stream-by-type "audio"',

                `--sub '${IN_FILE}'`,
                `--out '${OUT_FILE}'`,
                `--ref '${VIDEO}'`,
            ];

            if (files.includes(FILE_NAME)) {
                await mv(OUT_FILE, IN_FILE);
                runSubSync(cmd);
            }
            else {
                let stream = data.streams.find((s) => {
                    return s['tags']['language'] === lang &&
                           s.disposition!.forced === 0 &&
                           s.codec_type === 'subtitle';
                })!.index;

                if (!stream) {
                    stream = data.streams.find((s) => {
                        return s['tags']['language'] === lang &&
                           s.codec_type === 'subtitle';
                    })!.index;
                }

                if (!stream) {
                    console.warn(`No subtitle tracks were found for ${lang}`);
                    process.exit(0);
                }

                spawn('ffmpeg', [
                    '-i', `'${VIDEO}'`,
                    '-map', `0:${stream}`, `'${IN_FILE}'`,
                ], {
                    shell: true,
                    stdio: [process.stdin, process.stdout, process.stderr],

                }).on('close', () => {
                    runSubSync(cmd);
                });
            }
        });
    });
}
