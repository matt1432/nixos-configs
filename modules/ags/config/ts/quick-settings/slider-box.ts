const Audio = await Service.import('audio');

const { Box, Slider, Icon } = Widget;

const { Gdk } = imports.gi;
const display = Gdk.Display.get_default();

import Brightness from '../../services/brightness.ts';
import { SpeakerIcon } from '../misc/audio-icons.ts';


export default () => Box({
    class_name: 'slider-box',
    vertical: true,
    hpack: 'center',
    children: [

        Box({
            class_name: 'slider',
            vpack: 'start',
            hpack: 'center',

            children: [
                Icon({
                    size: 26,
                    class_name: 'slider-label',
                    icon: SpeakerIcon.bind(),
                }),

                Slider({
                    vpack: 'center',
                    max: 0.999,
                    draw_value: false,

                    on_change: ({ value }) => {
                        if (Audio.speaker) {
                            Audio.speaker.volume = value;
                        }
                    },

                    setup: (self) => {
                        self
                            .hook(Audio, () => {
                                self.value = Audio.speaker.volume || 0;
                            }, 'speaker-changed')

                            // OnClick
                            .on('button-press-event', () => {
                                if (!display) {
                                    return;
                                }
                                self.window.set_cursor(Gdk.Cursor.new_from_name(
                                    display,
                                    'grabbing',
                                ));
                            })

                            // OnRelease
                            .on('button-release-event', () => {
                                if (!display) {
                                    return;
                                }
                                self.window.set_cursor(Gdk.Cursor.new_from_name(
                                    display,
                                    'pointer',
                                ));
                            })

                            // OnHover
                            .on('enter-notify-event', () => {
                                if (!display) {
                                    return;
                                }
                                self.window.set_cursor(Gdk.Cursor.new_from_name(
                                    display,
                                    'pointer',
                                ));
                                self.toggleClassName('hover', true);
                            })

                            // OnHoverLost
                            .on('leave-notify-event', () => {
                                self.window.set_cursor(null);
                                self.toggleClassName('hover', false);
                            });
                    },
                }),
            ],
        }),

        Box({
            class_name: 'slider',
            vpack: 'start',
            hpack: 'center',

            children: [
                Icon({
                    class_name: 'slider-label',
                    icon: Brightness.bind('screenIcon'),
                }),

                Slider({
                    vpack: 'center',
                    draw_value: false,

                    on_change: ({ value }) => {
                        Brightness.screen = value;
                    },

                    setup: (self) => {
                        self
                            .hook(Brightness, () => {
                                self.value = Brightness.screen;
                            }, 'screen')

                            // OnClick
                            .on('button-press-event', () => {
                                if (!display) {
                                    return;
                                }
                                self.window.set_cursor(Gdk.Cursor.new_from_name(
                                    display,
                                    'grabbing',
                                ));
                            })

                            // OnRelease
                            .on('button-release-event', () => {
                                if (!display) {
                                    return;
                                }
                                self.window.set_cursor(Gdk.Cursor.new_from_name(
                                    display,
                                    'pointer',
                                ));
                            })

                            // OnHover
                            .on('enter-notify-event', () => {
                                if (!display) {
                                    return;
                                }
                                self.window.set_cursor(Gdk.Cursor.new_from_name(
                                    display,
                                    'pointer',
                                ));
                                self.toggleClassName('hover', true);
                            })

                            // OnHoverLost
                            .on('leave-notify-event', () => {
                                self.window.set_cursor(null);
                                self.toggleClassName('hover', false);
                            });
                    },
                }),
            ],
        }),

    ],
});
