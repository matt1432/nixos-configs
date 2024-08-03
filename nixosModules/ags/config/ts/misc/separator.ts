const { Box } = Widget;


export default (size: number, {
    vertical = false,
    css = '',
    ...props
} = {}) => {
    return Box({
        css: `${vertical ? 'min-height' : 'min-width'}: ${size}px; ${css}`,
        ...props,
    });
};
