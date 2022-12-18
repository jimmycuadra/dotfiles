local map = vim.keymap.set
local unmap = vim.keymap.del

-- Undo Neovim's default mapping for 'Y' so it performs 'yy' like in Vim
unmap("n", "Y")

-- Swap to the last viewed buffer
map("n", "<leader><leader>", "<c-^>")

-- Select everything in the buffer
map("n", "<leader>a", ":keepjumps normal! ggVG<cr>")

-- Cycle through buffers
map("n", "[b", ":bp<cr>")
map("n", "]b", ":bn<cr>")

-- Cycle through tabs
map("n", "[t", ":tabp<cr>")
map("n", "]t", ":tabn<cr>")

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

-- Bash-style cursor movement in the command line
map("c", "<c-a>", "<home>")
map("c", "<c-f>", "<right>")
map("c", "<c-b>", "<left>")
map("c", "<esc>b", "<s-left>")
map("c", "<esc>f", "<s-right>")

-- Move visual selection up and down
map("v", "J", ":m '>+1<cr>gv=gv")
map("v", "K", ":m '<-2<cr>gv=gv")
