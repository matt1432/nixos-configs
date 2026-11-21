/* eslint-disable no-magic-numbers */

import { Gdk } from 'ags/gtk4';

import { Bezier, BezierPoints, Point } from '../../lib';

/*
 * GTK4 doesn't let us read background colors from the style context,
 * so the fill color is passed directly instead of through CSS.
 */
export default ({ color = 'black', allocation = { width: 0, height: 0 } }) => (
    <box>
        <drawingarea
            widthRequest={allocation.width}
            heightRequest={allocation.height}
            $={(widget) => {
                const bgColor = new Gdk.RGBA();

                bgColor.parse(color);

                widget.set_draw_func((_, cairoContext) => {
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
                });
            }}
        />
    </box>
);
