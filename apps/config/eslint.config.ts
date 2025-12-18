import js from '@eslint/js';
import jsdoc from 'eslint-plugin-jsdoc';
import perfectionist from 'eslint-plugin-perfectionist';
import prettierRecommended from 'eslint-plugin-prettier/recommended';
import { defineConfig } from 'eslint/config';
import tseslint from 'typescript-eslint';

export default defineConfig(
    { ignores: ['dist', 'node_modules/**', 'types/**'] },
    {
        files: ['**/*.{js,jsx,ts,tsx}'],

        extends: [
            js.configs.recommended,
            ...tseslint.configs.recommended,
            jsdoc.configs['flat/recommended-typescript'],
        ],

        plugins: { perfectionist },

        rules: {
            // JSDoc settings
            'jsdoc/tag-lines': ['warn', 'any', { startLines: 1 }],
            'jsdoc/check-line-alignment': [
                'warn',
                'always',
                {
                    tags: ['param', 'arg', 'argument', 'property', 'prop'],
                },
            ],
            'jsdoc/no-types': 'off',

            // Misc
            'no-magic-numbers': [
                'error',
                {
                    ignore: [
                        -1, 0.1, 0, 1, 2, 3, 4, 5, 10, 12, 33, 66, 100, 255,
                        360, 450, 500, 1000,
                    ],
                    ignoreDefaultValues: true,
                    ignoreClassFieldInitialValues: true,
                },
            ],

            eqeqeq: ['error', 'smart'],

            'no-unused-vars': 'off',
            '@typescript-eslint/no-unused-vars': [
                'error',
                {
                    args: 'all',
                    argsIgnorePattern: '^_',
                    caughtErrors: 'all',
                    caughtErrorsIgnorePattern: '^_',
                    destructuredArrayIgnorePattern: '^_',
                    varsIgnorePattern: '^_',
                    ignoreRestSiblings: true,
                },
            ],

            // Imports
            'perfectionist/sort-imports': [
                'error',
                {
                    order: 'asc',
                    type: 'natural',
                },
            ],
            'perfectionist/sort-named-exports': 'error',
            'perfectionist/sort-named-imports': 'error',
        },
    },
    prettierRecommended,
    {
        rules: {
            curly: ['error', 'all'],

            'prettier/prettier': [
                'error',
                {
                    printWidth: 80,
                    tabWidth: 4,
                    useTabs: false,
                    semi: true,
                    singleQuote: true,
                    trailingComma: 'all',
                    bracketSameLine: false,
                    plugins: ['prettier-plugin-brace-style'],
                    braceStyle: 'stroustrup',
                },
            ],
        },
    },
);
