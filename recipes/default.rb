%w(
  bash_profile
  bashrc
  gemrc
  gitconfig
  gitignore
  irbrc
  railsrc
  rdebugrc
  tmux.conf
  vimrc
).each do |filename|
  cookbook_file "#{node[:dotfiles][:home_path]}/.#{filename}" do
    source filename
    owner node[:dotfiles][:user]
    group node[:dotfiles][:group]
  end
end

directory "#{node[:dotfiles][:home_path]}/.bundle" do
  owner node[:dotfiles][:user]
  group node[:dotfiles][:group]
end

directory "#{node[:dotfiles][:home_path]}/.vim" do
  owner node[:dotfiles][:user]
  group node[:dotfiles][:group]
end

directory "#{node[:dotfiles][:home_path]}/.vim/bundle" do
  owner node[:dotfiles][:user]
  group node[:dotfiles][:group]
end

directory "#{node[:dotfiles][:home_path]}/.vim/swap" do
  owner node[:dotfiles][:user]
  group node[:dotfiles][:group]
end

git "#{node[:dotfiles][:home_path]}/.vim/bundle/Vundle.vim" do
  repository "https://github.com/gmarik/Vundle.vim.git"
  user node[:dotfiles][:user]
  group node[:dotfiles][:group]
end
