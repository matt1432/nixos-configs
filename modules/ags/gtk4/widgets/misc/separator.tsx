import { Astal } from 'ags/gtk4';

export default ({
    size,
    vertical = false,
    css = '',
    ...rest
}: { size: number; css?: string } & Partial<Astal.Box>) => (
    <box
        css={`
            * {
                ${vertical ? 'min-height' : 'min-width'}: ${size}px;
                ${css}
            }
        `}
        {...rest}
    />
);
