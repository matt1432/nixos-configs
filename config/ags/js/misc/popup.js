const { Revealer, Box } = ags.Widget;
const { openWindow } = ags.App;

export const PopUp = ({name, child, transition = 'slide_down', ...params}) => Box({
  style: 'min-height:1px; min-width:1px',
  child: Revealer({
    ...params,
    transition,
    transitionDuration: 500,
    connections: [[ags.App, (revealer, currentName, visible) => {
      if (currentName === name) {
        revealer.reveal_child = visible;

        if (visible && name !== 'overview')
          openWindow('closer');
      }
    }]],
    child: child,
  }),
});
