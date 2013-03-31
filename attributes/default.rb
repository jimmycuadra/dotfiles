case node[:platform_family]
when "mac_os_x"
  default[:dotfiles] = {
    user: "jimmy",
    home_path: "/Users/jimmy"
  }
else
  default[:dotfiles] = {
    user: "vagrant",
    home_path: "/home/vagrant"
  }
end

default[:dotfiles][:vim_plugin_urls] = [
  "git://github.com/tpope/vim-pathogen.git",
  "git://github.com/kien/ctrlp.vim.git",
  "git://github.com/tpope/vim-fugitive.git",
  "git://github.com/skalnik/vim-vroom.git",
  "git://github.com/jgdavey/vim-railscasts.git",
  "git://github.com/kchmck/vim-coffee-script.git"
]
