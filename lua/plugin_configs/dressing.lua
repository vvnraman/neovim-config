-- 'stevearc/dressing.nvim'
local ok, dressing = pcall(require, 'dressing.nvim')
if not ok then
  print '"stevearc/dressing.nvim" not available'
  return
end
dressing.setup({
  input = {
    enabled = true,
    default_prompt = "Input> ",
  }
})
