const OskToggle = ags.Widget.EventBox({
  className: 'toggle-off',
  onPrimaryClickRelease: function() {
    OskToggle.toggleClassName('toggle-on', true);
  },

  child: ags.Widget.Box({
    className: 'osk-toggle',
    vertical: false,

    child: ags.Widget.Label({
      label: " 󰌌 ",
    }),
  }),
});

export const LeftBar = ags.Widget.Window({
  name: 'left-bar',
  layer: 'overlay',
  anchor: 'top left',

  child: ags.Widget.Box({
    className: 'transparent',
    vertical: false,
    
    children: [

      OskToggle,

      ags.Widget.EventBox({
        className: '',
        onPrimaryClickRelease: '',

        child: ags.Widget.Box({
          className: 'tablet-toggle',
          vertical: false,

          child: ags.Widget.Label({
            label: " 󰦧 ",
          }),
        }),
      }),

      ags.Widget.EventBox({
        className: '',
        onPrimaryClickRelease: '',

        child: ags.Widget.Box({
          className: 'heart-toggle',
          vertical: false,

          child: ags.Widget.Label({
            label: '',
          }),
        }),
      }),

    ],
  }),
});
