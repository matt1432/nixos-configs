import { subprocess } from 'astal';
import GObject, { register, signal } from 'astal/gobject';
import { App } from 'astal/gtk3';
import AstalIO from 'gi://AstalIO';

import { getWindow, hyprMessage } from '../lib';

const ON_RELEASE_TRIGGERS = ['released', 'TOUCH_UP', 'HOLD_END'];
const ON_CLICK_TRIGGERS = ['pressed', 'TOUCH_DOWN'];

import { CursorPos, Layer, LayerResult } from '../lib';
import PopupWindow from '../widgets/misc/popup-window';

@register()
export default class MonitorClicks extends GObject.Object {
    @signal(Boolean)
    declare procStarted: (state: boolean) => void;

    @signal(Boolean)
    declare procDestroyed: (state: boolean) => void;

    @signal(String)
    declare released: (procLine: string) => void;

    @signal(String)
    declare clicked: (procLine: string) => void;

    private process = null as AstalIO.Process | null;

    constructor() {
        super();
        this._initAppConnection();
    }

    private _startProc() {
        if (this.process) {
            return;
        }

        this.process = subprocess(['libinput', 'debug-events'], (output) => {
            if (output.includes('cancelled')) {
                return;
            }

            if (ON_RELEASE_TRIGGERS.some((p) => output.includes(p))) {
                MonitorClicks.detectClickedOutside('released');
                this.emit('released', output);
            }

            if (ON_CLICK_TRIGGERS.some((p) => output.includes(p))) {
                MonitorClicks.detectClickedOutside('clicked');
                this.emit('clicked', output);
            }
        });
        this.emit('proc-started', true);
    }

    private _killProc() {
        if (this.process) {
            this.process.kill();
            this.process = null;
            this.emit('proc-destroyed', true);
        }
    }

    private _initAppConnection() {
        App.connect('window-toggled', () => {
            const anyVisibleAndClosable = (
                App.get_windows() as PopupWindow[]
            ).some((w) => {
                const closable =
                    w.close_on_unfocus &&
                    !(
                        w.close_on_unfocus === 'none' ||
                        w.close_on_unfocus === 'stay'
                    );

                return w.visible && closable;
            });

            if (anyVisibleAndClosable) {
                this._startProc();
            }
            else {
                this._killProc();
            }
        });
    }

    private static _default: InstanceType<typeof MonitorClicks> | undefined;

    public static get_default() {
        if (!MonitorClicks._default) {
            MonitorClicks._default = new MonitorClicks();
        }

        return MonitorClicks._default;
    }

    public static async detectClickedOutside(clickStage: string) {
        const toClose = (App.get_windows() as PopupWindow[]).some((w) => {
            const closable =
                w.close_on_unfocus && w.close_on_unfocus === clickStage;

            return w.visible && closable;
        });

        if (!toClose) {
            return;
        }

        try {
            const layers = JSON.parse(
                await hyprMessage('j/layers'),
            ) as LayerResult;
            const pos = JSON.parse(
                await hyprMessage('j/cursorpos'),
            ) as CursorPos;

            Object.values(layers).forEach((key) => {
                const overlayLayer = key.levels['3'];

                if (overlayLayer) {
                    const noCloseWidgetsNames = ['bar-', 'osk', 'noanim-'];

                    const getNoCloseWidgets = (names: string[]) => {
                        const arr = [] as Layer[];

                        names.forEach((name) => {
                            arr.push(
                                overlayLayer.find((n) =>
                                    n.namespace.startsWith(name),
                                ) ||
                                    // Return an empty Layer if widget doesn't exist
                                    {
                                        address: '',
                                        x: 0,
                                        y: 0,
                                        w: 0,
                                        h: 0,
                                        namespace: '',
                                    },
                            );
                        });

                        return arr;
                    };
                    const clickIsOnWidget = (w: Layer) => {
                        return (
                            pos.x > w.x &&
                            pos.x < w.x + w.w &&
                            pos.y > w.y &&
                            pos.y < w.y + w.h
                        );
                    };

                    const noCloseWidgets =
                        getNoCloseWidgets(noCloseWidgetsNames);

                    const widgets = overlayLayer.filter((n) => {
                        const win = getWindow(n.namespace);

                        return (
                            win &&
                            win.close_on_unfocus &&
                            win.close_on_unfocus === clickStage
                        );
                    });

                    if (noCloseWidgets.some(clickIsOnWidget)) {
                        // Don't handle clicks when on certain widgets
                    }
                    else {
                        widgets.forEach((w) => {
                            if (
                                !(
                                    pos.x > w.x &&
                                    pos.x < w.x + w.w &&
                                    pos.y > w.y &&
                                    pos.y < w.y + w.h
                                )
                            ) {
                                getWindow(w.namespace)?.set_visible(false);
                            }
                        });
                    }
                }
            });
        }
        catch (e) {
            console.log(e);
        }
    }
}
