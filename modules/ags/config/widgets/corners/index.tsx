import { Astal } from 'ags/gtk3';
import Cairo from 'gi://cairo';

import RoundedCorner from './screen-corners';

const TopLeft = () => (
    <window
        name="cornertl"
        layer={Astal.Layer.OVERLAY}
        exclusivity={Astal.Exclusivity.IGNORE}
        anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT}
        $={(self) => {
            const value = new Cairo.Region();
            self.input_shape_combine_region(value);
        }}
    >
        {RoundedCorner('topleft')}
    </window>
);

const TopRight = () => (
    <window
        name="cornertr"
        layer={Astal.Layer.OVERLAY}
        exclusivity={Astal.Exclusivity.IGNORE}
        anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT}
        $={(self) => {
            const value = new Cairo.Region();
            self.input_shape_combine_region(value);
        }}
    >
        {RoundedCorner('topright')}
    </window>
);

const BottomLeft = () => (
    <window
        name="cornerbl"
        layer={Astal.Layer.OVERLAY}
        exclusivity={Astal.Exclusivity.IGNORE}
        anchor={Astal.WindowAnchor.BOTTOM | Astal.WindowAnchor.LEFT}
        $={(self) => {
            const value = new Cairo.Region();
            self.input_shape_combine_region(value);
        }}
    >
        {RoundedCorner('bottomleft')}
    </window>
);

const BottomRight = () => (
    <window
        name="cornerbr"
        layer={Astal.Layer.OVERLAY}
        exclusivity={Astal.Exclusivity.IGNORE}
        anchor={Astal.WindowAnchor.BOTTOM | Astal.WindowAnchor.RIGHT}
        $={(self) => {
            const value = new Cairo.Region();
            self.input_shape_combine_region(value);
        }}
    >
        {RoundedCorner('bottomright')}
    </window>
);

export default () =>
    [TopLeft(), TopRight(), BottomLeft(), BottomRight()] as Astal.Window[];
