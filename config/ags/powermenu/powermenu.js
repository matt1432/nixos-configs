export const Powermenu = ags.Widget.Window({
  name: 'powermenu',
  popup: true,
  layer: 'overlay',

  child: ags.Widget.CenterBox({
    className: 'powermenu',
    vertical: false,

    startWidget: ags.Widget.Button({
      className: 'shutdown',
      onPrimaryClickRelease: 'echo shutdown',

      child: ags.Widget.Label({
        label: '襤',
      }),
    }),

    centerWidget: ags.Widget.Button({
      className: 'reboot',
      onPrimaryClickRelease: 'echo reboot',

      child: ags.Widget.Label({
        label: '勒',
      }),
    }),

    endWidget: ags.Widget.Button({
      className: 'logout',
      onPrimaryClickRelease: 'echo logout',

      child: ags.Widget.Label({
        label: '',
      }),
    }),
  }),
});
