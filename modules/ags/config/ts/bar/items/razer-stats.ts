import { execAsync, interval } from 'resource:///com/github/Aylur/ags/utils.js';

const { Box, Icon, Label } = Widget;

const RAZER_POLL = 10000;
const LOW_BATT = 20;

const RazerBat = Variable({
    battery: 0,
    charging: false,
    sleeping: false,
    disconnected: true,
});


const fetchInfo = () => {
    execAsync([
        'bash',
        '-c',
        "polychromatic-cli -n 'Razer Naga Pro (Wired)' -k" +
        ' || ' +
        "polychromatic-cli -n 'Razer Naga Pro (Wireless)' -k",

    ]).then((out) => {
        const batteryMatches = out.split('\n')
            .filter((i) => i.includes('Battery'))[0]
            .match(/[0-9]+/);

        let sleeping = false;
        let battery = batteryMatches !== null ?
            parseInt(batteryMatches[0]) :
            0;

        // Don't set to zero when in sleep mode
        if (battery === 0 && RazerBat.value.battery > 10) {
            battery = RazerBat.value.battery;
            sleeping = true;
        }

        // If 'Wireless' isn't in the logs it means the cmd found 'Wired'
        const charging = !out.includes('Wireless');

        RazerBat.value = {
            battery,
            charging,
            sleeping,
            disconnected: false,
        };
    }).catch(() => {
        RazerBat.value.disconnected = true;
    });
};

interval(RAZER_POLL, fetchInfo);

// TODO: add charging indicator
export default () => Box({
    class_name: 'razer',
    children: [
        Icon({
            hpack: 'start',
            icon: RazerBat.bind().transform((v) => {
                return v.disconnected ?
                    'content-loading-symbolic' :
                    'mouse-razer-symbolic';
            }),
            setup: (self) => {
                self.hook(RazerBat, () => {
                    const v = RazerBat.value;

                    self.setCss(
                        v.disconnected ?
                            'margin-right: -5px;' :
                            '',
                    );

                    self.toggleClassName(
                        'high',
                        v.battery > 66,
                    );
                    self.toggleClassName(
                        'medium',
                        v.battery > LOW_BATT && v.battery <= 66,
                    );
                    self.toggleClassName(
                        'low',
                        v.battery <= LOW_BATT,
                    );
                });
            },
        }),

        Label({
            vpack: 'center',
            label: RazerBat.bind().transform((v) => {
                if (!v.disconnected) {
                    // TODO: find better way to indicate charging
                    return v.battery + (v.charging ? '󱐋' : '%');
                }

                return '';
            }),
        }),
    ],
});
