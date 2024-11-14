import { Widget } from 'astal/gtk3';


export default ({
    size,
    vertical = false,
    css = '',
    ...rest
}: { size: number } & Widget.BoxProps) => (
    <box
        css={`${vertical ? 'min-height' : 'min-width'}: ${size}px; ${css}`}
        {...rest}
    />
);
