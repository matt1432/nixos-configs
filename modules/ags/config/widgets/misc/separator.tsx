import { Astal } from 'ags/gtk3';
import { CCProps } from 'gnim';

export default ({
    size,
    vertical = false,
    css = '',
    ...rest
}: CCProps<
    Astal.Box,
    { size: number } & Partial<Astal.Box.ConstructorProps>
>) => (
    <box
        css={`
            ${vertical ? 'min-height' : 'min-width'}: ${size}px;
            ${css}
        `}
        {...rest}
    />
);
