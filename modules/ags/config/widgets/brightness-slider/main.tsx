import { bind } from 'astal';
import { Astal, Gtk } from 'astal/gtk3';

import Brightness from '../../services/brightness';
import PopupWindow from '../misc/popup-window';

export default () => {
    const brightness = Brightness.get_default();

    return (
        <PopupWindow
            name="brightness-slider"
            anchor={Astal.WindowAnchor.RIGHT | Astal.WindowAnchor.TOP}
        >
            <box className="widget" widthRequest={500}>
                <slider
                    hexpand
                    halign={Gtk.Align.FILL}
                    drawValue
                    cursor="pointer"
                    min={0}
                    max={100}
                    value={bind(brightness, 'screen').as((v) => v * 100)}
                    onDragged={(self) => {
                        brightness.screen = Number(
                            (self.value / 100).toFixed(2),
                        );
                    }}
                />
            </box>
        </PopupWindow>
    );
};
