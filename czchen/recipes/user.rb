require_package = %w(
    git
    npm
    python-pip
    ruby
    sudo
    vcsh
    vim-gnome
    zsh
)

pip_package = %w(
    flake8
    pip
    virtualenvwrapper
)

gem_package = %w(
    tmuxinator
)

npm_package = %w(
    LiveScript
    n
    npm
)

vcsh_repo = {
    :bzr             => 'https://github.com/czchen/bzr.vcsh',
    :debian          => 'https://github.com/czchen/debian.vcsh',
    :gdb             => 'https://github.com/czchen/gdb.vcsh',
    :gem             => 'https://github.com/czchen/gem.vcsh',
    :git             => 'https://github.com/czchen/git.vcsh',
    :gpg             => 'https://github.com/czchen/gpg.vcsh',
    :hg              => 'https://github.com/czchen/hg.vcsh',
    :mutt            => 'https://github.com/czchen/mutt.vcsh',
    :npm             => 'https://github.com/czchen/npm.vcsh',
    :python          => 'https://github.com/czchen/python.vcsh',
    :rime            => 'https://github.com/czchen/rime.vcsh',
    'sublime-text-3' => 'https://github.com/czchen/sublime-text-3.vcsh',
    :tmux            => 'https://github.com/czchen/tmux.vcsh',
    :vim             => 'https://github.com/czchen/vim.vcsh',
    :zsh             => 'https://github.com/czchen/zsh.vcsh',
}

require_package.each do |package_name|
    package package_name do
        action :install
    end
end

group 'sudo' do
    action :modify
    members node[:user][:user]
    append true
end

execute 'deploy vcsh' do
    user node[:user][:user]
    group node[:user][:group]

    vcsh_repo.each do |key, value|
        command "vcsh clone #{value} #{key.to_s} ; true"
    end
    not_if { vcsh_repo.empty? }
end

execute 'setup vim' do
    user node[:user][:user]
    group node[:user][:group]
    cwd node[:user][:home]
    command 'vim +BundleInstall +qall ; true'
    subscribes :run, resources(:execute => 'deploy vcsh')
end

execute 'setup python' do
    user node[:user][:user]
    group node[:user][:group]
    cwd node[:user][:home]

    pip_package.each do |package|
        command "pip install #{package}"
    end
    not_if { pip_package.empty? }

    subscribes :run, resources(:execute => 'deploy vcsh')
end

execute 'setup ruby' do
    user node[:user][:user]
    group node[:user][:group]
    cwd node[:user][:home]

    gem_package.each do |package|
        command "gem install #{package}"
    end
    not_if { gem_package.empty? }

    subscribes :run, resources(:execute => 'deploy vcsh')
end

execute 'setup nodejs' do
    user node[:user][:user]
    group node[:user][:group]
    cwd node[:user][:home]

    npm_package.each do |package|
        command "npm install -g #{package}"
    end
    not_if { npm_package.empty? }

    subscribes :run, resources(:execute => 'deploy vcsh')
end
