-- Wrapper around conform's builtin "injected" formatter that handles nix
-- interpolations (`${ ... }`) inside injected strings.
--
-- conform splits an injected string at each interpolation and formats every
-- piece on its own, which breaks as soon as an interpolation isn't inside a
-- string literal of the injected language (e.g. `local x = ${ ... }`).
--
-- To work around this, every interpolation inside an injected string is
-- replaced by a unique identifier before formatting, which makes the string a
-- single contiguous injection. The original interpolations are put back once
-- the injected code has been formatted.
return function(self, ctx, lines, callback)
    local builtin = require("conform.formatters.injected")

    local buf_lang = vim.treesitter.language.get_lang(vim.bo[ctx.buf].filetype)

    -- Line numbers would no longer match ctx.range once multi-line
    -- interpolations are collapsed, so leave range formatting alone.
    if buf_lang ~= "nix" or ctx.range then
        return builtin.format(self, ctx, lines, callback)
    end

    local text = table.concat(lines, "\n") .. "\n"
    local ok, parser = pcall(vim.treesitter.get_string_parser, text, "nix")
    if not ok then
        return builtin.format(self, ctx, lines, callback)
    end
    parser:parse(true)

    -- Spans of the strings injected with another language
    local spans = {}
    for lang, lang_tree in pairs(parser:children()) do
        if lang ~= "nix" then
            for _, ranges in ipairs(lang_tree:included_regions()) do
                if #ranges > 0 then
                    local first, last = ranges[1], ranges[#ranges]
                    table.insert(spans, { first[1], first[2], last[4], last[5] })
                end
            end
        end
    end

    local function before_or_eq(r1, c1, r2, c2)
        return r1 < r2 or (r1 == r2 and c1 <= c2)
    end

    local function in_span(sr, sc, er, ec)
        for _, span in ipairs(spans) do
            if before_or_eq(span[1], span[2], sr, sc) and before_or_eq(er, ec, span[3], span[4]) then
                return true
            end
        end
        return false
    end

    -- Outermost interpolations that are inside an injected string
    local interpolations = {}
    local query = vim.treesitter.query.parse("nix", "(interpolation) @interpolation")
    for _, node in query:iter_captures(parser:parse()[1]:root(), text) do
        local sr, sc, er, ec = node:range()
        local prev = interpolations[#interpolations]
        local nested = prev and before_or_eq(sr, sc, prev[3], prev[4]) and before_or_eq(prev[1], prev[2], sr, sc)
        if not nested and in_span(sr, sc, er, ec) then
            table.insert(interpolations, { sr, sc, er, ec })
        end
    end

    if #interpolations == 0 then
        return builtin.format(self, ctx, lines, callback)
    end

    -- Replace interpolations from last to first so earlier positions stay valid
    local masked = vim.deepcopy(lines)
    local originals = {}
    for i = #interpolations, 1, -1 do
        local sr, sc, er, ec = unpack(interpolations[i])
        local original = vim.list_slice(masked, sr + 1, er + 1)
        original[#original] = original[#original]:sub(1, ec)
        original[1] = original[1]:sub(sc + 1)
        originals[i] = table.concat(original, "\n")

        local placeholder = string.format("__nix_interp_%d__", i)
        masked[sr + 1] = masked[sr + 1]:sub(1, sc) .. placeholder .. masked[er + 1]:sub(ec + 1)
        for _ = sr + 2, er + 1 do
            table.remove(masked, sr + 2)
        end
    end

    builtin.format(self, ctx, masked, function(err, new_lines)
        if new_lines then
            local restored = table.concat(new_lines, "\n"):gsub("__nix_interp_(%d+)__", function(i)
                return originals[tonumber(i)]
            end)
            new_lines = vim.split(restored, "\n", { plain = true })
        end
        callback(err, new_lines)
    end)
end
