
const { Box, Icon, Label } = Widget;

const RAZER_POLL = 30000;
const LOW_BATT = 20;


// TODO: add charging indicator
const RazerBat = Variable(-1, {
    poll: [
        RAZER_POLL,
        [
            'bash',
            '-c',
            "polychromatic-cli -n 'Razer Naga Pro (Wired)' -k" +
            ' || ' +
            "polychromatic-cli -n 'Razer Naga Pro (Wireless)' -k",
        ],
        (out) => {
            const batteryMatches = out.split('\n')
                .filter((i) => i.includes('Battery'))[0]
                .match(/[0-9]+/);

            let battery = batteryMatches !== null ?
                parseInt(batteryMatches[0]) :
                -1;

            // Don't set to zero when in sleep mode
            if (battery === 0 && RazerBat.value > 10) {
                battery = RazerBat.value;
            }

            return battery;
        },
    ],
});

export default () => Box({
    class_name: 'razer',
    children: [
        Icon({
            hpack: 'start',
            icon: RazerBat.bind().transform((v) => {
                return v > -1 ?
                    'mouse-razer-symbolic' :
                    'content-loading-symbolic';
            }),
            setup: (self) => {
                self.hook(RazerBat, () => {
                    self.toggleClassName(
                        'high',
                        RazerBat.value > 66,
                    );
                    self.toggleClassName(
                        'medium',
                        RazerBat.value > LOW_BATT && RazerBat.value <= 66,
                    );
                    self.toggleClassName(
                        'low',
                        RazerBat.value <= LOW_BATT,
                    );
                });
            },
        }),

        Label({
            vpack: 'center',
            label: RazerBat.bind().transform((v) => {
                return v !== -1 ? `${v}%` : '';
            }),
        }),
    ],
});
