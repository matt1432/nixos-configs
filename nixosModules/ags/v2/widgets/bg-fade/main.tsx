import { Astal } from 'astal/gtk3';


export default () => {
    return (
        <window
            name="bg-fade"
            layer={Astal.Layer.BACKGROUND}
            exclusivity={Astal.Exclusivity.IGNORE}
            anchor={
                Astal.WindowAnchor.TOP |
                Astal.WindowAnchor.BOTTOM |
                Astal.WindowAnchor.LEFT |
                Astal.WindowAnchor.RIGHT
            }
            css={`
                background-image: -gtk-gradient (linear,
                    left top, left bottom,
                    from(rgba(0, 0, 0, 0.5)),
                    to(rgba(0, 0, 0, 0)));
            `}
        />
    );
};
