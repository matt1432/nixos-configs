import { spawnSync as spawn } from 'child_process';

import ffprobe from './ffprobe';
import { ISO6393To1 } from './lang-codes';

/* Types */
import { FfprobeStream } from 'fluent-ffmpeg';


const SPAWN_OPTS = {
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


// Global Vars
const subIndexes: number[] = [];
let videoPath: string;
let baseName: string;


/**
 * Gets the relative path to the subtitle file of a ffmpeg stream.
 *
 * @param sub the stream of the subtitles to extract
 * @returns the path of the subtitle file
 */
const getSubPath = (sub: FfprobeStream): string => {
    const language = ISO6393To1.get(sub.tags.language);

    const forced = sub.disposition?.forced === 0 ?
        '' :
        '.forced';

    const hearingImpaired = sub.disposition?.hearing_impaired === 0 ?
        '' :
        '.sdh';

    return `${baseName}${forced}.${language}${hearingImpaired}.srt`;
};

/**
 * Removes all subtitles streams from the video file.
 */
const removeContainerSubs = (): void => {
    spawn('mv', [
        videoPath,
        `${videoPath}.bak`,
    ], SPAWN_OPTS);

    spawn('ffmpeg', [
        '-i', `${videoPath}.bak`,
        '-map', '0',
        ...subIndexes.map((i) => ['-map', `-0:${i}`]).flat(),
        '-c', 'copy', videoPath,
    ], SPAWN_OPTS);

    spawn('rm', [
        `${videoPath}.bak`,
    ], SPAWN_OPTS);
};

/**
 * Extracts a sub of a video file to a subtitle file.
 *
 * @param sub the stream of the subtitles to extract
 */
const extractSub = (sub: FfprobeStream): void => {
    const subFile = getSubPath(sub);

    spawn('ffmpeg', [
        '-i', videoPath,
        '-map', `0:${sub.index}`, subFile,
    ], SPAWN_OPTS);

    subIndexes.push(sub.index);
};

/**
 * Sorts the list of streams to only keep subtitles
 * that can be extracted.
 *
 * @param lang    the language of the subtitles
 * @param streams the streams
 * @returns the streams that represent subtitles
 */
const findSubs = (
    lang: string,
    streams: FfprobeStream[],
): FfprobeStream[] => {
    const subs = streams.filter((s) => s.tags?.language &&
      s.tags.language === lang &&
      s.codec_type === 'subtitle');

    const pgs = subs.filter((s) => s.codec_name === 'hdmv_pgs_subtitle');

    // If we only have PGS subs, warn user
    if (pgs.length === subs.length) {
        console.warn(`No SRT subtitle tracks were found for ${lang}`);
    }

    // Remove PGS streams from subs
    return subs.filter((s) => s.codec_name !== 'hdmv_pgs_subtitle');
};

/**
 * Where the magic happens.
 */
const main = async(): Promise<void> => {
    // Get rid of video extension
    baseName = videoPath.split('/').at(-1)!.replace(/\.[^.]*$/, '');

    // ffprobe the video file to see available sub tracks
    const data = await ffprobe(videoPath);

    if (!data?.streams) {
        console.error('Couldn\'t find streams in video file');

        return;
    }

    // Check for languages wanted
    languages.forEach((lang) => {
        const subs = findSubs(lang, data.streams);

        if (subs.length === 0) {
            console.warn(`No subtitle tracks were found for ${lang}`);

            return;
        }

        // Extract all subs
        subs.forEach((sub) => {
            extractSub(sub);
        });
    });

    removeContainerSubs();
};


// Check if there are 2 params
if (video && languages) {
    videoPath = video;
    main();
}
else {
    console.error('Error: no argument passed');
    process.exit(1);
}
