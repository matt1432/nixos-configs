import { Astal } from 'astal';

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
            <box
                className="Bar"
            >
                <label label="hi" />
            </box>
        </BarRevealer>
    );
};
