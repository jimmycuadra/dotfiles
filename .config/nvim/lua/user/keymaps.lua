local map = vim.keymap.set
local unmap = vim.keymap.del

-- Undo Neovim's default mapping for 'Y' so it performs 'yy' like in Vim
unmap("n", "Y")

-- Swap to the last viewed buffer
map("n", "<leader><leader>", "<c-^>")

-- Copy full file path to clipboard
map("n", "<leader>ffn", ":let @*=expand('%:p')<cr>")
-- Copy relative file path to clipboard
map("n", "<leader>fn", ":let @*=expand('%')<cr>")

-- Switch between windows without <c-w>
map("n", "<c-h>", "<c-w>h")
map("n", "<c-j>", "<c-w>j")
map("n", "<c-k>", "<c-w>k")
map("n", "<c-l>", "<c-w>l")

-- "Very magic" searches. Regex (), |, and {} don't need to be escaped
map("n", "/", "/\\v")
