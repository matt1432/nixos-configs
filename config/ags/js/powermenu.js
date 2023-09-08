export const Powermenu = ags.Widget.Window({
  name: 'powermenu',
  popup: true,
  layer: 'overlay',

  child: ags.Widget.CenterBox({
    className: 'powermenu',
    vertical: false,

    startWidget: ags.Widget.Button({
      className: 'shutdown',
      onPrimaryClickRelease: 'systemctl poweroff',

      child: ags.Widget.Label({
        label: '襤',
      }),
    }),

    centerWidget: ags.Widget.Button({
      className: 'reboot',
      onPrimaryClickRelease: 'systemctl reboot',

      child: ags.Widget.Label({
        label: '勒',
      }),
    }),

    endWidget: ags.Widget.Button({
      className: 'logout',
      onPrimaryClickRelease: 'hyprctl dispatch exit',

      child: ags.Widget.Label({
        label: '',
      }),
    }),
  }),
});
