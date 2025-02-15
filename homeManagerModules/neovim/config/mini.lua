-- Taken from https://github.com/grahamc/system-configurations/blob/9e38ebea2a40c497d7d3fe0f05d8ef6a072d238c/dotfiles/neovim/lua/base/mini.lua

--- ai {{{
local ai = require('mini.ai');

local spec_treesitter = ai.gen_spec.treesitter;
local spec_pair = ai.gen_spec.pair;

ai.setup({
    custom_textobjects = {
        d = spec_treesitter({ a = '@function.outer', i = '@function.inner' }),
        f = spec_treesitter({ a = '@call.outer', i = '@call.inner' }),
        a = spec_treesitter({ a = '@parameter.outer', i = '@parameter.inner' }),
        C = spec_treesitter({ a = '@conditional.outer', i = '@conditional.inner' }),
        s = spec_treesitter({ a = '@assignment.lhs', i = '@assignment.rhs' }),

        -- Whole buffer
        g = function()
            local from = { line = 1, col = 1 };
            local to = {
                line = vim.fn.line('$'),
                col = math.max(vim.fn.getline('$'):len(), 1),
            };
            return { from = from, to = to };
        end,

        -- For markdown
        ['*'] = spec_pair('*', '*', { type = 'greedy' }),
        ['_'] = spec_pair('_', '_', { type = 'greedy' }),

        -- For lua
        [']'] = spec_pair('[', ']', { type = 'greedy' }),

        -- For Nix
        ["'"] = spec_pair("'", "'", { type = 'greedy' }),
    },

    silent = true,

    -- If I still want to select next/last I can use around_{next,last} textobjects
    search_method = 'cover',

    -- Number of lines within which textobject is searched
    n_lines = 100,
});
--}}}

-- surround {{{
local open_braces = {
    ['['] = ']',
    ['('] = ')',
    ['<'] = '>',
    ['{'] = '}',
    ["'"] = "'",
    ['"'] = '"',
};

local close_braces = {
    [']'] = '[',
    [')'] = '(',
    ['>'] = '<',
    ['}'] = '{',
};

local function get_braces(char)
    if open_braces[char] then
        return { char, open_braces[char] };
    elseif close_braces[char] then
        return { close_braces[char], char };
    else
        return nil;
    end;
end;

local function get_char()
    local ret_val, char_num = pcall(vim.fn.getchar);
    -- Return nil if error (e.g. <C-c>) or for control characters
    if not ret_val or char_num < 32 then
        return nil;
    end;
    local char = vim.fn.nr2char(char_num);

    return char;
end;

require('mini.surround').setup({
    n_lines = 50,
    search_method = 'cover',
    silent = true,
    custom_surroundings = {
        -- Search for two of the input char, d for double. Helpful for lua and Nix
        ['d'] = {
            input = function()
                local char = get_char();

                if char == nil or char == '' then
                    return nil;
                end;

                local braces = get_braces(char);

                if braces == nil then
                    return nil;
                end;

                return {
                    string.rep(braces[1], 2) .. '().-()' .. string.rep(braces[2], 2),
                };
            end,

            output = function()
                local char = get_char();

                if char == nil or char == '' then
                    return nil;
                end;

                local braces = get_braces(char);

                if braces == nil then
                    return nil;
                end;

                return {
                    left = string.rep(braces[1], 2),
                    right = string.rep(braces[2], 2),
                };
            end,
        },
    },
});
-- }}}
