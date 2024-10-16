import { Astal } from 'astal/gtk3';

import RoundedCorner from './screen-corners';


const TopLeft = () => (
    <window
        name="cornertl"
        layer={Astal.Layer.OVERLAY}
        exclusivity={Astal.Exclusivity.IGNORE}
        anchor={
            Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT
        }
        clickThrough={true}
    >
        {RoundedCorner('topleft')}
    </window>
);

const TopRight = () => (
    <window
        name="cornertr"
        layer={Astal.Layer.OVERLAY}
        exclusivity={Astal.Exclusivity.IGNORE}
        anchor={
            Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT
        }
        clickThrough={true}
    >
        {RoundedCorner('topright')}
    </window>
);

const BottomLeft = () => (
    <window
        name="cornerbl"
        layer={Astal.Layer.OVERLAY}
        exclusivity={Astal.Exclusivity.IGNORE}
        anchor={
            Astal.WindowAnchor.BOTTOM | Astal.WindowAnchor.LEFT
        }
        clickThrough={true}
    >
        {RoundedCorner('bottomleft')}
    </window>
);

const BottomRight = () => (
    <window
        name="cornerbr"
        layer={Astal.Layer.OVERLAY}
        exclusivity={Astal.Exclusivity.IGNORE}
        anchor={
            Astal.WindowAnchor.BOTTOM | Astal.WindowAnchor.RIGHT
        }
        clickThrough={true}
    >
        {RoundedCorner('bottomright')}
    </window>
);


export default () => [
    TopLeft(),
    TopRight(),
    BottomLeft(),
    BottomRight(),
];
