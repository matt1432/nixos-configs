const { execAsync, subprocess } = Utils;


class Clipboard extends Service {
    static {
        Service.register(this, {
            'clip-added': ['jsobject'],
            'history-searched': [],
        }, {
            clips: ['jsobject'],
        });
    }

    private static _MAX_CLIPS = 100;

    // Class Attributes
    private _clips_left = 0;

    private _clips = new Map<number, { clip: string, isImage: boolean }>();

    get clips() {
        return this._clips;
    }

    constructor() {
        super();

        this._getHistory();
        this._watchClipboard();
    }

    // Public Class Methods
    public copyOldItem(key: string | number): void {
        execAsync([
            'bash', '-c', `cliphist list | grep '^${key}' | cliphist decode | wl-copy`,
        ]);
    }

    // Private Class Methods
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
                'bash', '-c', `cliphist list | grep -a ${index} | cliphist decode`,
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

    private _addClip(newClip: [number, { clip: string, isImage: boolean }]) {
        if (
            ![...this.clips.values()]
                .map((c) => c.clip)
                .includes(newClip[1].clip)
        ) {
            this._clips.set(...newClip);
            this.emit('clip-added', newClip);
        }
        else {
            const oldClip = [...this.clips.entries()]
                .find(([_, { clip }]) => clip === newClip[1].clip);

            if (oldClip && oldClip[0] < newClip[0]) {
                this.clips.delete(oldClip[0]);
                this._clips.set(...newClip);
                this.emit('clip-added', newClip);
            }
        }
    }

    private _getHistory(n = Clipboard._MAX_CLIPS) {
        // FIXME: this is necessary when not putting a cap on clip amount
        // exec(`prlimit --pid ${exec('pgrep ags')} --nofile=10024:`);

        // This command comes from '../../clipboard/script.sh'
        execAsync('clipboard-manager').then((out) => {
            const rawClips = out.split('\n');

            this._clips_left = Math.min(rawClips.length - 1, n);

            rawClips.forEach(async(clip, i) => {
                if (i > n) {
                    return;
                }

                if (clip.includes('img')) {
                    this._decrementClipsLeft();

                    const newClip: [number, { clip: string, isImage: boolean }] = [
                        parseInt((clip.match('[0-9]+') ?? [''])[0]),
                        {
                            clip,
                            isImage: true,
                        },
                    ];

                    this._addClip(newClip);
                }
                else {
                    const decodedClip = await this._decodeItem(clip);

                    if (decodedClip) {
                        const newClip: [number, { clip: string, isImage: boolean }] = [
                            parseInt(clip),
                            {
                                clip: decodedClip,
                                isImage: false,
                            },
                        ];

                        this._addClip(newClip);
                    }
                }
            });
        }).catch((error) => console.error(error));
    }

    private _watchClipboard() {
        subprocess(
            ['wl-paste', '--watch', 'echo'],
            () => {
                this._getHistory(1);
            },
            () => { /**/ },
        );
    }
}

const clipboard = new Clipboard();

export default clipboard;
