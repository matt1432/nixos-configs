import Ffmpeg from 'fluent-ffmpeg';


export default (videoPath: string) => new Promise<Ffmpeg.FfprobeData>((resolve) => {
    Ffmpeg.ffprobe(videoPath, (_e, data) => {
        resolve(data);
    });
});
