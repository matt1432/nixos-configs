import { register } from 'astal';
import { Gtk, type ConstructProps } from 'astal/gtk4';

import astalify, { type AstalifyProps } from '../astalify';


export type ImageProps = ConstructProps<
    ImageClass,
    Gtk.Image.ConstructorProps & AstalifyProps
>;

@register({ GTypeName: 'Image' })
export class ImageClass extends astalify(Gtk.Image) {
    constructor({ cssName = 'image', ...props }: ImageProps = {}) {
        super({ cssName, ...props });
    }

    getChildren() { return []; }
}

export const Image = (props?: ImageProps) => new ImageClass(props);
