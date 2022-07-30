local map = vim.keymap.set
local silent = { silent = true }

-- Fuzzy find files with fzf
map("n", "<c-p>", ":Files<cr>", silent)
map("n", "<c-b>", ":Buffers<cr>", silent)
