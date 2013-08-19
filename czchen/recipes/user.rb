require_package = %w(
    git
    python3
    sudo
    vim-gnome
    zsh
)

require_package.each do |package_name|
    package package_name do
        action :install
    end
end

group node[:user][:group] do
    action :create
end

user node[:user][:user] do
    action :create
    home node[:user][:home]
    gid node[:user][:group]
    shell node[:user][:shell]
end

group 'sudo' do
    action :modify
    members node[:user][:user]
    append true
end

git node[:user][:dotfiles] do
    action :sync
    user node[:user][:user]
    group node[:user][:group]
    repository node[:user][:repository][:https]
    enable_submodules true
end

execute 'deploy dotfiles' do
    action :nothing
    user node[:user][:user]
    group node[:user][:group]
    cwd node[:user][:dotfiles]
    command './deploy'
    subscribes :run, resources(:git => node[:user][:dotfiles])
end
