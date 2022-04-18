-- 'folke/trouble.nvim'
local ok, trouble = pcall(require, 'trouble')
if not ok then
  print '"folke/trouble.nvim" not available'
  return
end
trouble.setup()
