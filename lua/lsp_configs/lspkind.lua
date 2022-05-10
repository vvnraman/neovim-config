-- 'onsails/lspkind-nvim'
local ok, _ = pcall(require, "lspkind")
if not ok then
    print('"onsails/lspkind" not available')
    return
end
