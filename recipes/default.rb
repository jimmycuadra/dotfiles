%w(
  bash_profile
  bashrc
  gemrc
  gitconfig
  gitignore
  irbrc
  railsrc
  tmux.conf
  vimrc
).each do |filename|
  cookbook_file "#{node[:dotfiles][:home_path]}/.#{filename}" do
    source filename
    owner node[:dotfiles][:user]
    group "staff"
  end
end

directory "#{node[:dotfiles][:home_path]}/.bundle" do
  owner node[:dotfiles][:user]
  group "staff"
end

cookbook_file "#{node[:dotfiles][:home_path]}/.bundle/config" do
  source "bundle_config"
  owner node[:dotfiles][:user]
  group "staff"
end

directory "#{node[:dotfiles][:home_path]}/.vim" do
  owner node[:dotfiles][:user]
  group "staff"
end

directory "#{node[:dotfiles][:home_path]}/.vim/bundle" do
  owner node[:dotfiles][:user]
  group "staff"
end

node[:dotfiles][:vim_plugin_urls].each do |url|
  plugin_name = url.split("/").last.sub(/\.git$/, "")

  git "#{node[:dotfiles][:home_path]}/.vim/bundle/#{plugin_name}" do
    repository url
    user node[:dotfiles][:user]
    group "staff"
  end
end
