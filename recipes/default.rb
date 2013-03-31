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
  cookbook_file "#{node[:local_user][:home]}/.#{filename}" do
    source filename
    owner node[:local_user][:name]
    group "staff"
  end
end

directory "#{node[:local_user][:home]}/.bundle" do
  owner node[:local_user][:name]
  group "staff"
end

cookbook_file "#{node[:local_user][:home]}/.bundle/config" do
  source "bundle_config"
  owner node[:local_user][:name]
  group "staff"
end

directory "#{node[:local_user][:home]}/.vim" do
  owner node[:local_user][:name]
  group "staff"
end

directory "#{node[:local_user][:home]}/.vim/bundle" do
  owner node[:local_user][:name]
  group "staff"
end
