/* eslint-disable no-magic-numbers */

import { Gdk, Gtk } from 'astal/gtk3';
import Cairo from 'cairo';

import { Bezier, BezierPoints, Point } from '../../lib';

/* Types */
type Side = 'top' | 'right' | 'bottom' | 'left';

const SIDES: Side[] = ['top', 'right', 'bottom', 'left'];

export default ({
    css = 'background-color: black;',
    allocation = { width: 0, height: 0 },
}) => (
    <box>
        <drawingarea
            css={css}
            setup={(widget) => {
                widget.set_size_request(allocation.width, allocation.height);

                widget.connect('draw', (_, cairoContext: Cairo.Context) => {
                    widget.set_size_request(
                        allocation.width,
                        allocation.height,
                    );

                    const styleContext = widget.get_style_context();

                    const bgColor = styleContext.get_background_color(
                        Gtk.StateFlags.NORMAL,
                    );

                    const borderWidth = styleContext.get_border(
                        Gtk.StateFlags.NORMAL,
                    );

                    const borderColor = Object.fromEntries(
                        SIDES.map((side) => [
                            side,
                            styleContext.get_property(
                                `border-${side}-color`,
                                Gtk.StateFlags.NORMAL,
                            ) as Gdk.RGBA,
                        ]),
                    ) as Record<Side, Gdk.RGBA>;

                    /*
                     * Draws a cubic bezier curve from the current point
                     * of the cairo context.
                     *
                     * @param dest  the destination point of the curve
                     * @param curve the cubic bezier's control points. this
                     *              is the same as a CSS easing function
                     */
                    const drawBezier = (
                        dest: Point,
                        curve: BezierPoints,
                    ): void => {
                        const start = new Point(cairoContext.getCurrentPoint());

                        // Converts the ratios to absolute coordinates
                        curve[0] = curve[0] * (dest.x - start.x) + start.x;
                        curve[1] = curve[1] * (dest.y - start.y) + start.y;
                        curve[2] = curve[2] * (dest.x - start.x) + start.x;
                        curve[3] = curve[3] * (dest.y - start.y) + start.y;

                        cairoContext.curveTo(...curve, dest.x, dest.y);
                    };

                    const colorBorder = (
                        side: Side,
                        start: Point,
                        dest: Point,
                        curve?: BezierPoints,
                    ) => {
                        cairoContext.moveTo(...start.values);

                        if (curve) {
                            drawBezier(dest, curve);
                        }
                        else {
                            cairoContext.lineTo(...dest.values);
                        }

                        cairoContext.setLineWidth(borderWidth[side]);
                        cairoContext.setSourceRGBA(
                            borderColor[side].red,
                            borderColor[side].green,
                            borderColor[side].blue,
                            borderColor[side].alpha,
                        );

                        cairoContext.stroke();
                    };

                    const bottomLeft = new Point({
                        x: 0,
                        y: allocation.height,
                    });

                    const topLeft = new Point({
                        x: 0,
                        y: 0,
                    });

                    const middleLeft = new Point({
                        x: allocation.width / 3,
                        y: allocation.height * 0.8,
                    });

                    const middleRight = new Point({
                        x: (allocation.width / 3) * 2,
                        y: allocation.height * 0.8,
                    });

                    const topRight = new Point({
                        x: allocation.width,
                        y: 0,
                    });

                    const bottomRight = new Point({
                        x: allocation.width,
                        y: allocation.height,
                    });

                    const bezier = new Bezier(0.76, 0, 0.24, 1);

                    // bottom left to top left
                    cairoContext.moveTo(...bottomLeft.values);
                    cairoContext.lineTo(...topLeft.values);

                    // top left to middle left
                    drawBezier(middleLeft, bezier.points);

                    // middle left to middle right
                    cairoContext.lineTo(...middleRight.values);

                    // middle right to top right
                    drawBezier(topRight, bezier.points);

                    // top right to bottom right
                    cairoContext.lineTo(...bottomRight.values);

                    // bottom right to bottom left
                    cairoContext.closePath();

                    // Add color
                    cairoContext.setSourceRGBA(
                        bgColor.red,
                        bgColor.green,
                        bgColor.blue,
                        bgColor.alpha,
                    );
                    cairoContext.fill();

                    colorBorder('left', bottomLeft, topLeft);
                    colorBorder('top', topLeft, middleLeft, bezier.points);
                    colorBorder('top', middleLeft, middleRight);
                    colorBorder('top', middleRight, topRight, bezier.points);
                    colorBorder('right', topRight, bottomRight);
                    colorBorder('bottom', bottomLeft, bottomRight);
                });
            }}
        />
    </box>
);
