import {
    mkdir,
    readdir as readDir,
    rename as mv,
} from 'fs/promises';

import { ffprobe as ffProbe } from 'fluent-ffmpeg';
import { spawnSync as spawn } from 'child_process';

import { ISO6391To3, ISO6393To1 } from './lang-codes';

const SPAWN_OPTS = {
    shell: true,
    stdio: [process.stdin, process.stdout, process.stderr],
};

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

const escapePath = (p: string) => p.replaceAll("'", "'\\''");

function getVideoPath(files: string[]) {
    const fileName = DIR.split('/').at(-1) ?? '';

    const videoFiles = files.filter((f) =>
        f.includes(fileName) && f.endsWith('mkv'));

    if (videoFiles.length === 0) {
        console.warn('No video files were found');
        process.exit(0);
    }

    return `${DIR}/${videoFiles[0]}`;
}

async function backupSubs(files: string[]) {
    // Check if backup folder already exists and create it if not
    if (!files.some((f) => f.endsWith('.srt.bak'))) {
        await mkdir(`${DIR}/.srt.bak`);
    }
    else {
        // TODO: compare with subs outside of backup dir
        const backups = await readDir(`${DIR}/.srt.bak`);

        // Remove synced subtitles from the list to sync
        // langs - backups
        langs = langs.filter((n) => !backups
            .some((s) => {
                const l2 = s.split('.').at(-2) ?? '';
                const l3 = ISO6391To3.get(l2);

                return n === l3;
            }));
    }

    if (langs.length === 0) {
        console.warn('Subtitles have already been synced');
        process.exit(0);
    }
}

function runSubSync(
    cmd: string[],
    onError = (error?: string) => {
        console.error(error);
    },
) {
    const { error } = spawn('subsync', cmd, SPAWN_OPTS);

    if (error) {
        onError(error.message);
    }

    spawn('chmod', ['-R', '775', `'${escapePath(DIR)}'`], SPAWN_OPTS);
}

async function main() {
    const files = await readDir(DIR);

    const VIDEO = getVideoPath(files);
    const BASE_NAME = VIDEO.split('/').at(-1)?.replace(/\.[^.]*$/, '');

    backupSubs(files);

    // ffprobe the video file to see available audio tracks
    ffProbe(VIDEO, (_e, data) => {
        if (!data?.streams) {
            console.error('Couldn\'t find streams in video file');
            process.exit(0);
        }

        const AVAIL_LANGS = data.streams
            .filter((s) => s.codec_type === 'audio')
            .map((s) => s['tags'] && s['tags']['language']);

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

                `--sub '${escapePath(IN_FILE)}'`,
                `--out '${escapePath(OUT_FILE)}'`,
                `--ref '${escapePath(VIDEO)}'`,
            ];

            if (files.includes(FILE_NAME)) {
                await mv(OUT_FILE, IN_FILE);

                runSubSync(cmd, async() => {
                    await mv(IN_FILE, OUT_FILE);
                });
            }
            else {
                let subs = data.streams.filter((s) => {
                    return s['tags'] &&
                           s['tags']['language'] &&
                           s['tags']['language'] === lang &&
                           s.codec_type === 'subtitle';
                });

                const pgs = subs.filter((s) => s.codec_name === 'hdmv_pgs_subtitle');

                // If we only have PGS subs, warn user
                if (pgs.length === subs.length) {
                    console.warn(`No SRT subtitle tracks were found for ${lang}`);
                }
                // Remove PGS streams from subs
                subs = subs.filter((s) => s.codec_name !== 'hdmv_pgs_subtitle');

                // Prefer normal subs
                if (subs.length !== 1) {
                    subs = subs.filter((s) => s.disposition?.forced === 0);
                }

                if (subs.length === 0) {
                    console.warn(`No subtitle tracks were found for ${lang}`);
                }
                else {
                    // Extract subtitle
                    spawn('ffmpeg', [
                        '-i', `'${escapePath(VIDEO)}'`,
                        '-map', `"0:${subs[0].index}"`, `'${escapePath(IN_FILE)}'`,
                    ], SPAWN_OPTS);

                    // Delete subtitle from video
                    spawn('mv', [
                        `'${escapePath(VIDEO)}'`,
                        `'${escapePath(VIDEO)}.bak'`,
                    ], SPAWN_OPTS);

                    spawn('ffmpeg', [
                        '-i', `'${escapePath(VIDEO)}.bak'`,
                        '-map', '0',
                        '-map', `-0:${subs[0].index}`,
                        '-c', 'copy', `'${escapePath(VIDEO)}'`,
                    ], SPAWN_OPTS);

                    spawn('rm', [`'${escapePath(VIDEO)}.bak'`], SPAWN_OPTS);

                    // Sync extracted subtitle
                    runSubSync(cmd, async() => {
                        await mv(IN_FILE, OUT_FILE);
                    });
                }
            }
        });
    });
}
