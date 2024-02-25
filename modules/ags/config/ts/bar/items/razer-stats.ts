const { Box, Icon, ProgressBar } = Widget;

const RAZER_POLL = 30000;
const LOW_BATT = 20;


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
            const battery = out.split('\n')
                .filter((i) => i.includes('Battery'))[0]
                .match(/[0-9]+/);

            return battery !== null ? parseInt(battery[0]) : -1;
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
        }),

        ProgressBar({
            vpack: 'center',
            value: RazerBat.bind().transform((v) => v >= 0 ? v / 100 : 0),
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

    ],
});
