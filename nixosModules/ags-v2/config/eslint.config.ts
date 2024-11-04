import eslint from '@eslint/js';
import jsdoc from 'eslint-plugin-jsdoc';
import stylistic from '@stylistic/eslint-plugin';
import tseslint from 'typescript-eslint';


export default tseslint.config({
    files: ['**/*.{js,ts,tsx}'],
    ignores: ['node_modules/**', 'types/**'],

    extends: [
        eslint.configs.recommended,
        jsdoc.configs['flat/recommended-typescript'],
        stylistic.configs['recommended-flat'],
        ...tseslint.configs.recommended,
        ...tseslint.configs.stylistic,
    ],

    rules: {
        // JSDoc settings
        'jsdoc/tag-lines': ['warn', 'any', { startLines: 1 }],
        'jsdoc/check-line-alignment': ['warn', 'always', {
            tags: ['param', 'arg', 'argument', 'property', 'prop'],
        }],
        'jsdoc/no-types': 'off',

        // Newer settings
        '@typescript-eslint/no-extraneous-class': ['off'],
        '@typescript-eslint/no-implied-eval': ['off'],
        'class-methods-use-this': 'off',
        '@stylistic/no-multiple-empty-lines': 'off',
        '@stylistic/jsx-indent-props': 'off',
        'no-use-before-define': 'off',
        '@typescript-eslint/no-use-before-define': 'error',
        '@stylistic/indent-binary-ops': 'off',
        '@stylistic/max-statements-per-line': [
            'error',
            { max: 2 },
        ],

        // Pre-flat config
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

        'array-callback-return': [
            'error',
            {
                allowImplicit: true,
                checkForEach: true,
            },
        ],
        'no-constructor-return': [
            'error',
        ],
        'no-unreachable-loop': [
            'error',
            {
                ignore: [
                    'ForInStatement',
                    'ForOfStatement',
                ],
            },
        ],
        'block-scoped-var': [
            'error',
        ],
        'curly': [
            'warn',
        ],
        'default-case-last': [
            'warn',
        ],
        'default-param-last': [
            'error',
        ],
        'eqeqeq': [
            'error',
            'smart',
        ],
        'func-names': [
            'warn',
            'never',
        ],
        'func-style': [
            'warn',
            'expression',
        ],
        'logical-assignment-operators': [
            'warn',
            'always',
        ],
        'no-array-constructor': [
            'error',
        ],
        'no-empty-function': [
            'warn',
        ],
        'no-empty-static-block': [
            'warn',
        ],
        'no-extend-native': [
            'error',
        ],
        'no-extra-bind': [
            'warn',
        ],
        'no-implicit-coercion': [
            'warn',
        ],
        'no-iterator': [
            'error',
        ],
        'no-labels': [
            'error',
        ],
        'no-lone-blocks': [
            'error',
        ],
        'no-lonely-if': [
            'error',
        ],
        'no-loop-func': [
            'error',
        ],
        'no-magic-numbers': [
            'error',
            {
                ignore: [
                    -1,
                    0.1,
                    0,
                    1,
                    2,
                    3,
                    4,
                    5,
                    10,
                    12,
                    33,
                    66,
                    100,
                    255,
                    360,
                    450,
                    500,
                    1000,
                ],
                ignoreDefaultValues: true,
                ignoreClassFieldInitialValues: true,
            },
        ],
        'no-multi-assign': [
            'error',
        ],
        'no-new-wrappers': [
            'error',
        ],
        'no-object-constructor': [
            'error',
        ],
        'no-proto': [
            'error',
        ],
        'no-return-assign': [
            'error',
        ],
        'no-sequences': [
            'error',
        ],
        'no-shadow': [
            'error',
            {
                builtinGlobals: true,
                allow: [
                    'Window',
                ],
            },
        ],
        'no-undef-init': [
            'warn',
        ],
        'no-undefined': [
            'error',
        ],
        'no-useless-constructor': [
            'warn',
        ],
        'no-useless-escape': [
            'off',
        ],
        'no-useless-return': [
            'error',
        ],
        'no-var': [
            'error',
        ],
        'no-void': [
            'off',
        ],
        'no-with': [
            'error',
        ],
        'object-shorthand': [
            'error',
            'always',
        ],
        'one-var': [
            'error',
            'never',
        ],
        'operator-assignment': [
            'warn',
            'always',
        ],
        'prefer-arrow-callback': [
            'error',
        ],
        'prefer-const': [
            'error',
        ],
        'prefer-object-has-own': [
            'error',
        ],
        'prefer-regex-literals': [
            'error',
        ],
        'prefer-template': [
            'warn',
        ],
        'no-prototype-builtins': 'off',
        '@typescript-eslint/no-var-requires': [
            'off',
        ],
        '@stylistic/array-bracket-newline': [
            'warn',
            'consistent',
        ],
        '@stylistic/array-bracket-spacing': [
            'warn',
            'never',
        ],
        '@stylistic/arrow-parens': [
            'warn',
            'always',
        ],
        '@stylistic/brace-style': [
            'warn',
            'stroustrup',
            { allowSingleLine: true },
        ],
        '@stylistic/comma-dangle': [
            'warn',
            'always-multiline',
        ],
        '@stylistic/comma-spacing': [
            'warn',
            {
                before: false,
                after: true,
            },
        ],
        '@stylistic/comma-style': [
            'error',
            'last',
        ],
        '@stylistic/dot-location': [
            'error',
            'property',
        ],
        '@stylistic/function-call-argument-newline': [
            'warn',
            'consistent',
        ],
        '@stylistic/function-paren-newline': [
            'warn',
            'consistent',
        ],
        '@stylistic/indent': [
            'warn',
            4,
            {
                SwitchCase: 1,
                ignoreComments: true,
                ignoredNodes: ['TemplateLiteral > *'],
            },
        ],
        '@stylistic/key-spacing': [
            'warn',
            {
                beforeColon: false,
                afterColon: true,
            },
        ],
        '@stylistic/keyword-spacing': [
            'warn',
            {
                before: true,
            },
        ],
        '@stylistic/linebreak-style': [
            'error',
            'unix',
        ],
        '@stylistic/lines-between-class-members': [
            'warn',
            'always',
            {
                exceptAfterSingleLine: true,
            },
        ],
        '@stylistic/max-len': [
            'warn',
            {
                code: 105,
                ignoreComments: true,
                ignoreTrailingComments: true,
                ignoreUrls: true,
            },
        ],
        '@stylistic/multiline-ternary': [
            'warn',
            'always-multiline',
        ],
        '@stylistic/new-parens': [
            'error',
        ],
        '@stylistic/no-mixed-operators': [
            'warn',
        ],
        '@stylistic/no-mixed-spaces-and-tabs': [
            'error',
        ],
        '@stylistic/no-multi-spaces': [
            'error',
        ],
        '@stylistic/no-tabs': [
            'error',
        ],
        '@stylistic/no-trailing-spaces': [
            'error',
        ],
        '@stylistic/no-whitespace-before-property': [
            'warn',
        ],
        '@stylistic/nonblock-statement-body-position': [
            'error',
            'below',
        ],
        '@stylistic/object-curly-newline': [
            'warn',
            {
                consistent: true,
            },
        ],
        '@stylistic/object-curly-spacing': [
            'warn',
            'always',
        ],
        '@stylistic/operator-linebreak': [
            'warn',
            'after',
        ],
        '@stylistic/padded-blocks': [
            'error',
            'never',
        ],
        '@stylistic/padding-line-between-statements': [
            'warn',
            {
                blankLine: 'always',
                prev: '*',
                next: 'return',
            },
            {
                blankLine: 'always',
                prev: [
                    'const',
                    'let',
                    'var',
                ],
                next: '*',
            },
            {
                blankLine: 'any',
                prev: [
                    'const',
                    'let',
                    'var',
                ],
                next: [
                    'const',
                    'let',
                    'var',
                ],
            },
            {
                blankLine: 'always',
                prev: [
                    'case',
                    'default',
                ],
                next: '*',
            },
        ],
        '@stylistic/quote-props': [
            'error',
            'consistent-as-needed',
        ],
        '@stylistic/quotes': [
            'error',
            'single',
            {
                avoidEscape: true,
            },
        ],
        '@stylistic/semi': [
            'error',
            'always',
        ],
        '@stylistic/semi-spacing': [
            'warn',
        ],
        '@stylistic/space-before-blocks': [
            'warn',
        ],
        '@stylistic/space-before-function-paren': [
            'warn',
            'never',
        ],
        '@stylistic/space-infix-ops': [
            'warn',
        ],
        '@stylistic/spaced-comment': [
            'warn',
            'always',
        ],
        '@stylistic/switch-colon-spacing': [
            'warn',
        ],
        '@stylistic/wrap-regex': [
            'warn',
        ],
    },
});
