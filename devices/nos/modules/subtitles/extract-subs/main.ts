import Ffmpeg from 'fluent-ffmpeg';
import { spawnSync as spawn } from 'child_process';

import { ISO6393To1 } from './lang-codes';


const SPAWN_OPTS = {
    shell: true,
    stdio: [process.stdin, process.stdout, process.stderr],
};

/**
 * These are the cli arguments
 *
 * @param videoPath the directory in which we want to sync the subtitles
 * @param languages a comma-separated list of languages (3 letters) to sync the subtitles
 */
const video = process.argv[2];
const languages = process.argv[3]?.split(',');


const getSubPath = (baseName: string, sub: Ffmpeg.FfprobeStream): string => {
    const language = ISO6393To1.get(sub.tags.language);

    const forced = sub.disposition?.forced === 0 ?
        '' :
        '.forced';

    const hearingImpaired = sub.disposition?.hearing_impaired === 0 ?
        '' :
        '.sdh';

    return `${baseName}${forced}.${language}${hearingImpaired}.srt`;
};

const main = (videoPath: string) => {
    const subIndexes: number[] = [];
    const baseName = videoPath.split('/').at(-1)!.replace(/\.[^.]*$/, '');

    // ffprobe the video file to see available sub tracks
    Ffmpeg.ffprobe(videoPath, (_e, data) => {
        if (!data?.streams) {
            console.error('Couldn\'t find streams in video file');

            return;
        }

        languages.forEach((lang) => {
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

            if (subs.length === 0) {
                console.warn(`No subtitle tracks were found for ${lang}`);

                return;
            }

            subs.forEach((sub) => {
                const subFile = getSubPath(baseName, sub);

                // Extract subtitle
                spawn('ffmpeg', [
                    '-i', `'${videoPath}'`,
                    '-map', `"0:${sub.index}"`, `'${subFile}'`,
                ], SPAWN_OPTS);

                subIndexes.push(sub.index);
            });
        });

        // Delete subtitles from video
        spawn('mv', [
            `'${videoPath}'`,
            `'${videoPath}.bak'`,
        ], SPAWN_OPTS);

        spawn('ffmpeg', [
            '-i', `'${videoPath}.bak'`,
            '-map', '0',
            ...subIndexes.map((i) => [
                '-map', `-0:${i}`,
            ]).flat(),
            '-c', 'copy', `'${videoPath}'`,
        ], SPAWN_OPTS);

        spawn('rm', [
            `'${videoPath}.bak'`,
        ], SPAWN_OPTS);
    });
};

const escapePath = (p: string): string => p.replaceAll("'", "'\\''");

// Check if there are 2 params
if (video && languages) {
    main(escapePath(video));
}
else {
    console.error('Error: no argument passed');
    process.exit(1);
}
