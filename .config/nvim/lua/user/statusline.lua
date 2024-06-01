local M = {}

local modes = {
  ["n"] = "NORMAL",
  ["no"] = "O-PENDING",
  ["nov"] = "O-PENDING",
  ["noV"] = "O-PENDING",
  ["no\22"] = "O-PENDING",
  ["niI"] = "NORMAL",
  ["niR"] = "NORMAL",
  ["niV"] = "NORMAL",
  ["nt"] = "NORMAL",
  ["v"] = "VISUAL",
  ["vs"] = "VISUAL",
  ["V"] = "V-LINE",
  ["Vs"] = "V-LINE",
  ["\22"] = "V-BLOCK",
  ["\22s"] = "V-BLOCK",
  ["s"] = "SELECT",
  ["S"] = "S-LINE",
  ["\19"] = "S-BLOCK",
  ["i"] = "INSERT",
  ["ic"] = "INSERT",
  ["ix"] = "INSERT",
  ["R"] = "REPLACE",
  ["Rc"] = "REPLACE",
  ["Rx"] = "REPLACE",
  ["Rv"] = "V-REPLACE",
  ["Rvc"] = "V-REPLACE",
  ["Rvx"] = "V-REPLACE",
  ["c"] = "COMMAND",
  ["cv"] = "EX",
  ["ce"] = "EX",
  ["r"] = "REPLACE",
  ["rm"] = "MORE",
  ["r?"] = "CONFIRM",
  ["!"] = "SHELL",
  ["t"] = "TERMINAL",
}

local mode_colors = {
  ["VISUAL"] = "%#DiffText#",
  ["V-BLOCK"] = "%#DiffText#",
  ["V-LINE"] = "%#DiffText#",
  ["SELECT"] = "%#DiffText#",
  ["S-LINE"] = "%#DiffText#",
  ["S-BLOCK"] = "%#DiffText#",

  ["REPLACE"] = "%#DiffDelete#",
  ["V-REPLACE"] = "%#DiffDelete#",

  ["INSERT"] = "%#PmenuSel#",

  ["COMMAND"] = "%#SignColumn#",
  ["EX"] = "%#SignColumn#",
  ["MORE"] = "%#SignColumn#",
  ["CONFIRM"] = "%#SignColumn#",

  ["TERMINAL"] = "%#TermCursor#",
}

local function get_mode()
  local mode = vim.api.nvim_get_mode().mode
  return modes[mode] or "NORMAL"
end

local function get_mode_color(mode)
  return mode_colors[mode] or "%#PMenu#"
end

local function progress()
  local cur = vim.fn.line(".")
  local total = vim.fn.line("$")
  if cur == 1 then
    return "Top"
  elseif cur == total then
    return "Bot"
  else
    return math.floor(cur / total * 100) .. "%%"
  end
end

-- Default statusline:
--
-- :set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

-- Vim statusline:
--
-- set laststatus=2
-- set statusline=%#CursorLineNr#
-- set statusline+=%-3n
-- set statusline+=\ %f
-- set statusline+=\ %y
--
-- set statusline+=\ %h%m%r%w
-- set statusline+=%=
-- set statusline+=%-14(%l/%L,%c%V%)
-- set statusline+=%<%-6P
-- set statusline+=%2#WarningMsg#
-- set statusline+=\ %2{coc#status()}
-- set statusline+=\ %2#PmenuSel#
-- set statusline+=%{'\ '.FugitiveHead(7).'\ '}

function M.statusline()
  local mode = get_mode()
  local mode_color = get_mode_color(mode)

  local parts = {
    mode_color,
    " " .. mode .. " ",
    "%#CursorLineNr#",
    " #%n ",
    "%f %h%m%r%=",
    "%#Visual#",
    vim.lsp.status(),
    "%#CursorLineNr# ",
  }

  local ft = vim.bo.filetype

  if ft ~= "" then
    table.insert(parts, ft:gsub("%%", "%%%%") .. " ")
  end

  vim.list_extend(parts, {
    "%l/%L,%c ",
    progress() .. " ",
  })

  local git_head = vim.api.nvim_exec2("echo FugitiveHead(7)", { output = true })

  if git_head.output ~= "" then
    vim.list_extend(parts, {
      "%#PmenuSel# " .. git_head.output .. " ",
    })
  end

  return table.concat(parts, "")
end

return M
