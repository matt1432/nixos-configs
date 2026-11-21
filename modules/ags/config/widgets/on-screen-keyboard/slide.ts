/* eslint-disable no-magic-numbers */

import { Astal } from 'ags/gtk4';

/*
 * In GTK3 the OSK was slid off-screen with a negative CSS margin on the
 * window's child, which also shrank the window. In GTK4 that shrinks the
 * layer surface to a height of 0, which makes the compositor drop it, so we
 * animate the layer-shell bottom margin of the window instead.
 */

export type Easing = (t: number) => number;

// Same as CSS cubic-bezier(0.36, 0, 0.66, -0.56), a.k.a. easeInBack
export const easeInBack: Easing = (t) => {
    const c1 = 1.70158;
    const c3 = c1 + 1;

    return c3 * t * t * t - c1 * t * t;
};

// Close to CSS ease-in-out
export const easeInOut: Easing = (t) =>
    t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2;

export class Slider {
    private tickId: number | null = null;

    constructor(private readonly win: Astal.Window) {}

    /**
     * @returns the current offset of the window from its shown position
     */
    get offset() {
        return this.win.marginBottom;
    }

    /**
     * Moves the window instantly, cancelling any running animation.
     *
     * @param offset the bottom margin in px (0 is fully shown)
     */
    set(offset: number) {
        this.cancel();
        this.win.marginBottom = Math.round(offset);
    }

    /**
     * Animates the window to an offset.
     *
     * @param offset   the bottom margin in px (0 is fully shown)
     * @param duration in ms
     * @param easing   the easing function
     */
    animate(offset: number, duration: number, easing: Easing) {
        this.cancel();

        const from = this.offset;
        let start: number | null = null;

        this.tickId = this.win.add_tick_callback((_, clock) => {
            const now = clock.get_frame_time() / 1000;

            start ??= now;

            const t = Math.min((now - start) / duration, 1);

            this.win.marginBottom = Math.round(
                from + (offset - from) * easing(t),
            );

            if (t >= 1) {
                this.tickId = null;

                return false;
            }

            return true;
        });
    }

    cancel() {
        if (this.tickId !== null) {
            this.win.remove_tick_callback(this.tickId);
            this.tickId = null;
        }
    }
}
