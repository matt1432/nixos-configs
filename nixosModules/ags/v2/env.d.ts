/* eslint-disable-next-line @typescript-eslint/no-unused-vars */
const SRC: string;

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
