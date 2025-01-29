import { bind } from 'astal';
import { App } from 'astal/gtk3';

import Brightness from '../../../services/brightness';

import PopupWindow from '../../misc/popup-window';


export default () => {
    const brightness = Brightness.get_default();

    return (
        <button
            cursor="pointer"
            className="bar-item brightness"

            onButtonReleaseEvent={(self) => {
                const win = App.get_window('win-brightness-slider') as PopupWindow;

                win.set_x_pos(
                    self.get_allocation(),
                    'right',
                );

                win.set_visible(!win.get_visible());
            }}
        >
            <overlay passThrough>
                <circularprogress
                    startAt={0.75}
                    endAt={0.75}
                    value={bind(brightness, 'screen')}
                    rounded
                />

                <icon icon={bind(brightness, 'screenIcon')} />
            </overlay>
        </button>
    );
};
