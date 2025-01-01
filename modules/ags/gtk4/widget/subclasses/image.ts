/* eslint-disable @typescript-eslint/no-explicit-any */

import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify from './astalify';


export type ImageProps = ConstructProps<
    Image,
    Gtk.Image.ConstructorProps & { css: string }
>;

@register({ GTypeName: 'Image' })
export class Image extends astalify(Gtk.Image) {
    constructor(props?: ImageProps) { super(props as any); }

    getChildren() { return []; }
}
