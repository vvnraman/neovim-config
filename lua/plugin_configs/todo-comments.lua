-- 'folke/todo-comments.nvim'
local ok, todo_comments = pcall(require, "todo-comments")
if not ok then
    print('"folke/todo-comments.nvim" not available')
    return
end

todo_comments.setup()
