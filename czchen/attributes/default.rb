if ENV.has_key? 'TRAVIS'
    default[:user] = {
        :user  => 'travis',
        :group => 'travis',
        :home  => '/home/travis',
        :shell => '/bin/bash',
    }
else
    default[:user] = {
        :user  => 'czchen',
        :group => 'czchen',
        :home  => '/home/czchen',
        :shell => '/bin/zsh',
    }
end

default[:package][:system] = %w(
    autojump
    build-essential
    cmake
    git
    manpages
    manpages-dev
    manpages-posix
    manpages-posix-dev
    mutt-patched
    npm
    p7zip-full
    python-pip
    ruby
    sudo
    vcsh
    vim-gnome
    zsh
)

default[:package][:vcsh] = {
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

default[:package][:pip] = %w(
    flake8
    pip
    virtualenvwrapper
)

default[:package][:gem] = %w(
    tmuxinator
)

if ENV.has_key? 'TRAVIS'
    default[:package][:npm] = []
else
    default[:package][:npm] = %w(
        LiveScript
        n
        npm
    )
    default[:package][:config][:npm][:prefix] = "#{default[:user][:home]}/.local"
end
