-- 'numToStr/Comment.nvim'
local ok, comment = pcall(require, "Comment")
if not ok then
    print('"numToStr/Comment.nvim" not available')
    return
end
comment.setup()
