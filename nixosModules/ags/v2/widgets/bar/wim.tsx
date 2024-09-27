import { Astal } from 'astal';

import Battery from './items/battery';

import BarRevealer from './fullscreen';


export default () => {
    return (
        <BarRevealer
            exclusivity={Astal.Exclusivity.EXCLUSIVE}
            anchor={
                Astal.WindowAnchor.TOP |
                Astal.WindowAnchor.LEFT |
                Astal.WindowAnchor.RIGHT
            }
        >
            <box className="bar widget">
                <Battery />
            </box>
        </BarRevealer>
    );
};
