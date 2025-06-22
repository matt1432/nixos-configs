-- Modified from https://github.com/lauranaujokat/nvim/blob/4102c789d05667f636107e3dae4ac589053ee88d/lua/setups/heirline.lua#L4

local conditions = require('heirline.conditions');
local utils = require('heirline.utils');

---@class Palette
---@field [string] any
local dracula = require('dracula').colors();

local colors = {
    bright_bg = dracula.selection,
    dark_bg = dracula.menu,
    bright_fg = dracula.fg,
    red = dracula.red,
    dark_red = utils.get_highlight('DiffDelete').bg,
    green = dracula.green,
    blue = dracula.blue,
    gray = utils.get_highlight('NonText').fg,
    orange = utils.get_highlight('Constant').fg,
    purple = utils.get_highlight('Statement').fg,
    cyan = dracula.cyan,
    diag_warn = utils.get_highlight('DiagnosticWarn').fg,
    diag_error = utils.get_highlight('DiagnosticError').fg,
    diag_hint = utils.get_highlight('DiagnosticHint').fg,
    diag_info = utils.get_highlight('DiagnosticInfo').fg,
    git_del = utils.get_highlight('GitSignsDelete').fg,
    git_add = utils.get_highlight('GitSignsAdd').fg,
    git_change = utils.get_highlight('GitSignsChange').fg,
};

require('heirline').load_colors(colors);

local ViMode = {
    -- get vim current mode, this information will be required by the provider
    -- and the highlight functions, so we compute it only once per component
    -- evaluation and store it as a component attribute
    init = function(self)
        self.mode = vim.fn.mode(1);

        -- execute this only once, this is required if you want the ViMode
        -- component to be updated on operator pending mode
        if not self.once then
            vim.api.nvim_create_autocmd('ModeChanged', {
                pattern = '*:*o',
                command = 'redrawstatus',
            });
            self.once = true;
        end;
    end,

    static = {
        mode_names = {
            n = 'N',
            no = 'N?',
            nov = 'N?',
            noV = 'N?',
            ['no\22'] = 'N?',
            niI = 'Ni',
            niR = 'Nr',
            niV = 'Nv',
            nt = 'Nt',
            v = 'V',
            vs = 'Vs',
            V = 'V_',
            Vs = 'Vs',
            ['\22'] = '^V',
            ['\22s'] = '^V',
            s = 'S',
            S = 'S_',
            ['\19'] = '^S',
            i = 'I',
            ic = 'Ic',
            ix = 'Ix',
            R = 'R',
            Rc = 'Rc',
            Rx = 'Rx',
            Rv = 'Rv',
            Rvc = 'Rv',
            Rvx = 'Rv',
            c = 'C',
            cv = 'Ex',
            r = '...',
            rm = 'M',
            ['r?'] = '?',
            ['!'] = '!',
            t = 'T',
        },

        mode_colors = {
            n = 'red',
            i = 'green',
            v = 'cyan',
            V = 'cyan',
            ['\22'] = 'cyan',
            c = 'orange',
            s = 'purple',
            S = 'purple',
            ['\19'] = 'purple',
            R = 'orange',
            r = 'orange',
            ['!'] = 'red',
            t = 'red',
        },
    },

    -- To be extra meticulous, we can also add some vim statusline syntax to
    -- control the padding and make sure our string is always at least 2
    -- characters long. Plus a nice Icon.
    provider = function(self)
        return ' ' .. self.mode_names[self.mode] .. '%)';
    end,

    -- Same goes for the highlight. Now the foreground will change according to the current mode.
    hl = function(self)
        local mode = self.mode:sub(1, 1); -- get only the first mode character
        return { fg = self.mode_colors[mode], bold = true };
    end,

    -- Re-evaluate the component only on ModeChanged event
    update = {
        'ModeChanged',
    },
};

local FileNameBlock = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0);
    end,
};

-- FileNameBlock children
local FileIcon = {
    init = function(self)
        local filename = self.filename;
        local extension = vim.fn.fnamemodify(filename, ':e');
        self.icon, _ = require('nvim-web-devicons').get_icon(filename, extension, { default = true });
    end,

    provider = function(self)
        return self.icon and (self.icon .. ' ');
    end,

    hl = { fg = utils.get_highlight('Directory').fg },
};

local FileName = {
    provider = function(self)
        -- first, trim the pattern relative to the current directory. For other
        -- options, see :h filename-modifers
        local filename = vim.fn.fnamemodify(self.filename, ':.');
        if filename == '' then
            return '[No Name]';
        end;
        -- now, if the filename would occupy more than 1/4th of the available
        -- space, we trim the file path to its initials
        -- See Flexible Components section below for dynamic truncation
        if not conditions.width_percent_below(#filename, 0.25) then
            filename = vim.fn.pathshorten(filename);
        end;
        return filename;
    end,

    hl = { fg = utils.get_highlight('Directory').fg },
};

local FileFlags = {
    {
        condition = function()
            return vim.bo.modified;
        end,
        provider = '[+]',
        hl = { fg = 'green' },
    },
    {
        condition = function()
            return not vim.bo.modifiable or vim.bo.readonly;
        end,
        provider = '',
        hl = { fg = 'orange' },
    },
};

local FileNameModifer = {
    hl = function()
        if vim.bo.modified then
            -- use `force` because we need to override the child's hl foreground
            return { fg = 'cyan', bold = true, force = true };
        end;
    end,
};

-- let's add the children to our FileNameBlock component
FileNameBlock = utils.insert(
    FileNameBlock,
    FileIcon,
    utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
    unpack(FileFlags),                       -- A small optimisation, since their parent does nothing
    { provider = '%<' }                      -- this means that the statusline is cut here when there's not enough space
);

local Ruler = {
    provider = ' line: %l col: %c',
    hl = { fg = 'green', bold = false },
};

local ScrollRuler = {
    -- %l = current line number
    -- %L = number of lines in the buffer
    -- %c = column number
    -- %P = percentage through file of displayed window
    provider = '%P',
};

local ScrollBar = {
    static = {
        sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' },
        -- sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
    },

    provider = function(self)
        local curr_line = vim.api.nvim_win_get_cursor(0)[1];
        local lines = vim.api.nvim_buf_line_count(0);
        local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1;
        return string.rep(self.sbar[i], 2);
    end,

    hl = { fg = 'cyan', bg = 'bright_bg' },
};

local LSPActive = {
    condition = conditions.lsp_attached,
    update = { 'LspAttach', 'LspDetach' },

    provider = function()
        local names = {};
        for _, server in pairs(vim.lsp.get_clients()) do
            table.insert(names, server.name);
        end;
        return ' [' .. table.concat(names, ' ') .. '] ';
    end,

    hl = { fg = 'green', bold = false },
};

local spinner_frames = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' };

-- From https://github.com/mhartington/dotfiles/blob/5961460e3a492f7815259a692fca5ca2a1df924a/config/nvim/lua/mh/statusline/lsp_status.lua#L4
local function get_lsp_progress()
    local messages = require('lsp-status/messaging').messages;
    local buf_messages = messages();
    local msgs = {};

    for _, msg in ipairs(buf_messages) do
        local contents;

        if msg.progress then
            contents = msg.title;

            if msg.spinner then
                contents = spinner_frames[(msg.spinner % #spinner_frames) + 1] .. ' ' .. contents;
            end;
        elseif msg.status then
            contents = msg.content;

            if msg.uri then
                local space = math.min(60, math.floor(0.6 * vim.fn.winwidth(0)));
                local filename = vim.uri_to_fname(msg.uri);

                filename = vim.fn.fnamemodify(filename, ':~:.');

                if #filename > space then
                    filename = vim.fn.pathshorten(filename);
                end;

                contents = '(' .. filename .. ') ' .. contents;
            end;
        else
            contents = msg.content;
        end;

        table.insert(msgs, contents);
    end;

    return table.concat(msgs, ' ');
end;

local LSPMessages = {
    provider = function()
        local progress = get_lsp_progress();

        if progress == '' then
            return '';
        else
            return '  ' .. progress;
        end;
    end,
    hl = { fg = 'purple' },
};

local Diagnostics = {
    condition = conditions.has_diagnostics,

    static = {
        error_icon = '  ',
        warn_icon = '  ',
        info_icon = '  ',
        hint_icon = '  ',
    },

    init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR });
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN });
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT });
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO });
    end,

    update = { 'DiagnosticChanged', 'BufEnter' },

    {
        provider = function(self)
            -- 0 is just another output, we can decide to print it or not!
            return self.errors > 0 and (self.error_icon .. self.errors);
        end,
        hl = { fg = 'diag_error' },
    },
    {
        provider = function(self)
            return self.warnings > 0 and (self.warn_icon .. self.warnings);
        end,
        hl = { fg = 'diag_warn' },
    },
    {
        provider = function(self)
            return self.info > 0 and (self.info_icon .. self.info);
        end,
        hl = { fg = 'diag_info' },
    },
    {
        provider = function(self)
            return self.hints > 0 and (self.hint_icon .. self.hints);
        end,
        hl = { fg = 'diag_hint' },
    },
};

local Git = {
    condition = conditions.is_git_repo,

    init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict;
        self.has_changes = self.status_dict.added ~= 0 or
            self.status_dict.removed ~= 0 or
            self.status_dict.changed ~= 0;
    end,

    hl = { fg = 'orange' },

    { -- git branch name
        provider = function(self)
            return ' ' .. self.status_dict.head;
        end,
        hl = { bold = true },
    },
    -- You could handle delimiters, icons and counts similar to Diagnostics
    {
        condition = function(self)
            return self.has_changes;
        end,
        provider = '(',
    },
    {
        provider = function(self)
            local count = self.status_dict.added or 0;
            return count > 0 and ('+' .. count);
        end,
        hl = { fg = 'git_add' },
    },
    {
        provider = function(self)
            local count = self.status_dict.removed or 0;
            return count > 0 and ('-' .. count);
        end,
        hl = { fg = 'git_del' },
    },
    {
        provider = function(self)
            local count = self.status_dict.changed or 0;
            return count > 0 and ('~' .. count);
        end,
        hl = { fg = 'git_change' },
    },
    {
        condition = function(self)
            return self.has_changes;
        end,
        provider = ')',
    },
};

local Align = { provider = '%=' };
local Space = { provider = ' ' };

Left = utils.surround({ '', '' }, 'bright_bg', { ViMode, Diagnostics, LSPMessages });
Middle = utils.surround({ '', '' }, 'bright_bg', { LSPActive, FileNameBlock, Ruler });
Right = utils.surround({ '', '' }, 'bright_bg', { Git, Space, ScrollRuler, Space, ScrollBar });

local DefaultStatusline = {
    hl = { bg = 'dark_bg' },
    condition = function()
        return true;
    end,
    Left,
    Align,
    Middle,
    Align,
    Right,
};

local StatusLines = {
    hl = function()
        if conditions.is_active() then
            return 'StatusLine';
        else
            return 'StatusLineNC';
        end;
    end,

    -- the first statusline with no condition, or which condition returns true is used.
    -- think of it as a switch case with breaks to stop fallthrough.
    fallthrough = false,

    DefaultStatusline,
};

-- Make it global
vim.opt.laststatus = 3;

require('heirline').setup({
    statusline = StatusLines,
});
