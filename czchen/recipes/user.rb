require_package = %w(
    git
    npm
    python-pip
    python3
    ruby
    sudo
    vim-gnome
    zsh
)

pip_package = %w(
    flake8
    pip
    virtualenvwrapper
)

gem_package = %w(
)

npm_package = %w(
    LiveScript
    n
    npm
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
    user node[:user][:user]
    group node[:user][:group]
    cwd node[:user][:dotfiles]
    command './deploy'
    subscribes :run, resources(:git => node[:user][:dotfiles])
end

execute 'setup vim' do
    user node[:user][:user]
    group node[:user][:group]
    cwd node[:user][:home]
    command 'vim +BundleInstall +qall'
    subscribes :run, resources(:execute => 'deploy dotfiles')
end

execute 'setup python' do
    user node[:user][:user]
    group node[:user][:group]
    cwd node[:user][:home]

    pip_package.each do |package|
        command "pip install #{package}"
    end
    not_if { pip_package.empty? }

    subscribes :run, resources(:execute => 'deploy dotfiles')
    # FIXME: remove global python-pip in favor of local pip
end

execute 'setup ruby' do
    user node[:user][:user]
    group node[:user][:group]
    cwd node[:user][:home]

    gem_package.each do |package|
        command "gem install #{package}"
    end
    not_if { gem_package.empty? }

    subscribes :run, resources(:execute => 'deploy dotfiles')
end

execute 'setup nodejs' do
    user node[:user][:user]
    group node[:user][:group]
    cwd node[:user][:home]

    npm_package.each do |package|
        command "npm install -g #{package}"
    end
    not_if { npm_package.empty? }

    subscribes :run, resources(:execute => 'deploy dotfiles')
    # FIXME: remove global npm in favor of local npm
end
