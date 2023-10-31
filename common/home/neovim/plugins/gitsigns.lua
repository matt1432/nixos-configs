local gitsigns = require("gitsigns")

local function visual_stage()
    local first_line = vim.fn.line('v')
    local last_line = vim.fn.getpos('.')[2]
    gitsigns.stage_hunk({ first_line, last_line })
    -- Switch back to normal mode, there may be a cleaner way to do this
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 't', false)
end

vim.keymap.set("v", "gbhs", function()
    visual_stage()
end)

gitsigns.setup();
