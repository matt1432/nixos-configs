import { App, Widget } from '../../imports.js';
const { Revealer, Box, Window } = Widget;
const { openWindow } = App;


export const PopupWindow = ({
  name,
  child,
  transition = 'slide_down',
  ...params
}) => Window({
  name,
  popup: true,
  visible: false,
  layer: 'overlay',
  ...params,

  child: Box({
    style: 'min-height:1px; min-width:1px',
    child: Revealer({
      transition,
      transitionDuration: 500,
      connections: [[App, (revealer, currentName, visible) => {
        if (currentName === name) {
          revealer.reveal_child = visible;

          if (visible && name !== 'overview')
            openWindow('closer');
        }
      }]],
      child: child,
    }),
  }),
});
