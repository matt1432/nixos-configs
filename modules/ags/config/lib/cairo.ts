type PointProps = [number, number] | {
    x: number
    y: number
} | number;

export class Point {
    public x = 0;
    public y = 0;

    get values(): [number, number] {
        return [this.x, this.y];
    }

    constructor(props?: PointProps, y?: number) {
        if (typeof props === 'number') {
            if (y) {
                this.x = props;
                this.y = y;
            }
            else {
                throw new Error('Wrong props');
            }
        }
        else if (Array.isArray(props)) {
            this.x = props[0];
            this.y = props[1];
        }
        else if (props) {
            this.x = props.x;
            this.y = props.y;
        }
    }
}

export type BezierPoints = [number, number, number, number];

export class Bezier {
    private _points: BezierPoints;

    get points() {
        return [...this._points] as BezierPoints;
    }

    constructor(x1: number, y1: number, x2: number, y2: number) {
        this._points = [x1, y1, x2, y2];
    }
}
