import { createBinding } from 'ags';
import { Astal, Gtk } from 'ags/gtk4';

import { pointer } from '../../lib/widgets';
import Brightness from '../../services/brightness';
import PopupWindow from '../misc/popup-window';

export default () => {
    const brightness = Brightness.get_default();

    return (
        <PopupWindow
            name="brightness-slider"
            anchor={Astal.WindowAnchor.RIGHT | Astal.WindowAnchor.TOP}
        >
            <box class="widget" widthRequest={500}>
                <slider
                    hexpand
                    halign={Gtk.Align.FILL}
                    drawValue
                    cursor={pointer}
                    min={0}
                    max={100}
                    value={createBinding(brightness, 'screen').as(
                        (v) => v * 100,
                    )}
                    onChangeValue={(_self, _scroll, value) => {
                        const clamped = Math.min(Math.max(value, 0), 100);

                        brightness.screen = Number((clamped / 100).toFixed(2));
                    }}
                />
            </box>
        </PopupWindow>
    );
};
