-- https://github.com/ggandor/leap.nvim
local ok, leap = pcall(require, "leap")
if not ok then
    if PLUGIN_MISSING_NOTIFY then
        print('"ggandor/leap.nvim" not available')
    end
    return
end
leap.add_default_mappings()
leap.opts.highlight_unlabeled_phase_one_targets = true
leap.opts.case_sensitive = true
