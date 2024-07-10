const { execAsync } = Utils;


// TODO: add wl-paste --watch to not have to get history every time
const MAX_CLIPS = 100;

class Clipboard extends Service {
    static {
        Service.register(this, {
            'clip-added': ['string'],
            'history-searched': [],
        }, {
            clips: ['jsobject'],
        });
    }

    private _clips_left = 0;
    private _clips: Map<number, { clip: string; isImage: boolean }> = new Map();

    get clips() {
        return this._clips;
    }


    private _decrementClipsLeft() {
        if (--this._clips_left === 0) {
            this.emit('history-searched');
            // FIXME: this is necessary when not putting a cap on clip amount
            // exec(`prlimit --pid ${exec('pgrep ags')} --nofile=1024:`);
        }
    }

    private async _decodeItem(index: string): Promise<string | null> {
        try {
            const decodedItem = await execAsync([
                'bash', '-c', `cliphist list | grep ${index} | cliphist decode`,
            ]);

            this._decrementClipsLeft();

            return decodedItem;
        }
        catch (error) {
            console.error(error);
            this._decrementClipsLeft();

            return null;
        }
    }

    public copyOldItem(key: string | number): void {
        execAsync([
            'bash', '-c', `cliphist list | grep ${key} | cliphist decode | wl-copy`,
        ]);
    }

    public getHistory() {
        this._clips = new Map();

        // FIXME: this is necessary when not putting a cap on clip amount
        // exec(`prlimit --pid ${exec('pgrep ags')} --nofile=10024:`);

        // This command comes from '../../clipboard/script.sh'
        execAsync('clipboard-manager')
            .then((out) => {
                const rawClips = out.split('\n');

                this._clips_left = Math.min(rawClips.length - 1, MAX_CLIPS);

                rawClips.forEach(async(clip, i) => {
                    if (i > MAX_CLIPS) {
                        return;
                    }

                    if (clip.includes('img')) {
                        this._decrementClipsLeft();
                        this._clips.set(
                            parseInt((clip.match('[0-9]+') ?? [''])[0]),
                            {
                                clip,
                                isImage: true,
                            },
                        );
                    }
                    else {
                        const decodedClip = await this._decodeItem(clip);

                        if (decodedClip) {
                            this._clips.set(
                                parseInt(clip),
                                {
                                    clip: decodedClip,
                                    isImage: false,
                                },
                            );
                        }
                    }
                });
            })
            .catch((error) => console.error(error));
    }
}

const clipboard = new Clipboard();

export default clipboard;
