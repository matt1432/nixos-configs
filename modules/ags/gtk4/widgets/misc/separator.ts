import { Box, BoxProps } from '../subclasses';

export default ({
    size,
    vertical = false,
    css = '',
    ...rest
}: { size: number } & BoxProps) =>
    Box({
        css: `* { ${vertical ? 'min-height' : 'min-width'}: ${size}px; ${css} }`,
        ...rest,
    } as BoxProps);
