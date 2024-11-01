/* eslint-disable @typescript-eslint/no-unused-vars, no-var */

const SRC: string;

var Brightness: import('./services/brightness').default;

function closeAll(): void;

declare module 'inline:*' {
    const content: string;

    export default content;
}

declare module '*.sass' {
    const content: string;

    export default content;
}

declare module '*.scss' {
    const content: string;

    export default content;
}

declare module '*.css' {
    const content: string;

    export default content;
}
