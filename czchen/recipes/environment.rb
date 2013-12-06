package = %w(
    build-essential
    git
    manpages
    manpages-dev
    manpages-posix
    manpages-posix-dev
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

package.each do |package_name|
    package package_name do
        action :install
    end
end

group 'sudo' do
    action :modify
    members node[:user][:user]
    append true
end

vcsh_repo.each do |key, value|
    execute "deploy #{key}.vcsh" do
        user node[:user][:user]
        group node[:user][:group]
        command "vcsh clone #{value} #{key.to_s}"
        ignore_failure true
    end
end

execute 'setup vim' do
    user node[:user][:user]
    group node[:user][:group]
    cwd node[:user][:home]
    command 'vim +BundleInstall +qall ; true'
    subscribes :run, resources(:execute => 'deploy vim.vcsh')
end

execute 'setup python' do
    user node[:user][:user]
    group node[:user][:group]
    cwd node[:user][:home]

    pip_package.each do |package|
        command "pip install #{package}"
    end
    not_if { pip_package.empty? }

    subscribes :run, resources(:execute => 'deploy python.vcsh')
end

execute 'setup ruby' do
    user node[:user][:user]
    group node[:user][:group]
    cwd node[:user][:home]

    gem_package.each do |package|
        command "gem install #{package}"
    end
    not_if { gem_package.empty? }

    subscribes :run, resources(:execute => 'deploy gem.vcsh')
end

execute 'setup nodejs' do
    user node[:user][:user]
    group node[:user][:group]
    cwd node[:user][:home]

    npm_package.each do |package|
        command "npm install -g #{package}"
    end
    not_if { npm_package.empty? }

    subscribes :run, resources(:execute => 'deploy npm.vcsh')
end