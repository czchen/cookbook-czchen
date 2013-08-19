default[:user][:user] = 'czchen'
default[:user][:group] = default[:user][:user]
default[:user][:home] = "/home/#{default[:user][:user]}"
default[:user][:shell] = '/bin/zsh'
default[:user][:dotfiles] = "#{default[:user][:home]}/.dotfiles"
default[:user][:repository][:https] = 'https://github.com/czchen/dotfiles.git'
default[:user][:repository][:ssh] = 'git@github.com:czchen/dotfiles.git'
