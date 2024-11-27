import { Gtk } from 'astal/gtk3';
import Cairo from 'cairo';

/* Types */
interface Point {
    x: number
    y: number
}
type Bezier = [number, number, number, number];

export default ({
    css = 'background-color: black;',
    allocation = { width: 0, height: 0 },
}) => (
    <box>
        <drawingarea
            css={css}

            setup={(widget) => {
                widget.set_size_request(allocation.width, allocation.height);

                const styleContext = widget.get_style_context();
                const bgColor = styleContext.get_background_color(Gtk.StateFlags.NORMAL);

                widget.connect('draw', (_, cairoContext: Cairo.Context) => {
                    const drawBezier = (dest: Point, curve: Bezier) => {
                        curve[0] *= (dest.x - cairoContext.getCurrentPoint()[0]);
                        curve[0] += cairoContext.getCurrentPoint()[0];

                        curve[1] *= (dest.y - cairoContext.getCurrentPoint()[1]);
                        curve[1] += cairoContext.getCurrentPoint()[1];

                        curve[2] *= (dest.x - cairoContext.getCurrentPoint()[0]);
                        curve[2] += cairoContext.getCurrentPoint()[0];

                        curve[3] *= (dest.y - cairoContext.getCurrentPoint()[1]);
                        curve[3] += cairoContext.getCurrentPoint()[1];

                        cairoContext.curveTo(...curve, dest.x, dest.y);
                    };

                    // bottom left to top left
                    cairoContext.moveTo(0, allocation.height);
                    cairoContext.lineTo(0, 0);

                    // top left to middle left
                    drawBezier(
                        { x: allocation.width / 3, y: allocation.height * 0.8 },
                        [0.76, 0, 0.24, 1],
                    );

                    // middle left to middle right
                    cairoContext.lineTo((allocation.width / 3) * 2, allocation.height * 0.8);

                    // middle right to top right
                    drawBezier(
                        { x: allocation.width, y: 0 },
                        [0.76, 0, 0.24, 1],
                    );

                    // top right to bottom right
                    cairoContext.lineTo(allocation.width, allocation.height);

                    // bottom right to bottom left
                    cairoContext.closePath();

                    // Add color
                    cairoContext.setSourceRGBA(bgColor.red, bgColor.green, bgColor.blue, bgColor.alpha);
                    cairoContext.fill();
                });
            }}
        />
    </box>
);
