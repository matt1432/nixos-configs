import { Astal, Gdk } from 'ags/gtk4';
import Cairo from 'gi://cairo';

import RoundedCorner from './screen-corners';

type Place = 'topleft' | 'topright' | 'bottomleft' | 'bottomright';

const ANCHORS: Record<Place, Astal.WindowAnchor> = {
    topleft: Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT,
    topright: Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT,
    bottomleft: Astal.WindowAnchor.BOTTOM | Astal.WindowAnchor.LEFT,
    bottomright: Astal.WindowAnchor.BOTTOM | Astal.WindowAnchor.RIGHT,
};

const NAMES: Record<Place, string> = {
    topleft: 'cornertl',
    topright: 'cornertr',
    bottomleft: 'cornerbl',
    bottomright: 'cornerbr',
};

const Corner = (place: Place) => (
    <window
        name={NAMES[place]}
        namespace={NAMES[place]}
        layer={Astal.Layer.OVERLAY}
        exclusivity={Astal.Exclusivity.IGNORE}
        anchor={ANCHORS[place]}
        visible
        $={(self) => {
            // Make the corners click-through
            const setInputRegion = () => {
                self.get_surface()?.set_input_region(
                    new Cairo.Region() as unknown as Parameters<
                        Gdk.Surface['set_input_region']
                    >[0],
                );
            };

            if (self.get_realized()) {
                setInputRegion();
            }
            self.connect('realize', setInputRegion);
            self.connect('map', setInputRegion);
        }}
    >
        {RoundedCorner(place)}
    </window>
);

export default () =>
    (['topleft', 'topright', 'bottomleft', 'bottomright'] as Place[]).map(
        Corner,
    ) as Astal.Window[];
