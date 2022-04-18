-- 'onsails/lspkind-nvim'
local ok, lspkind = pcall(require, 'lspkind')
if not ok then
  print '"onsails/lspkind" not available'
  return
end

-- This is configured in 'nvim-cmp' config.
