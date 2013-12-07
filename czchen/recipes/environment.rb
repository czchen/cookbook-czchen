node[:package][:system].each do |item|
    package item do
        action :install
    end
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

node[:package][:vcsh].each do |key, value|
    execute "deploy #{key}.vcsh" do
        user node[:user][:user]
        group node[:user][:group]
        command "vcsh clone #{value} #{key.to_s}"
        ignore_failure true
    end
end

node[:package][:vcsh].each do |key, value|
    execute "write-gitignore #{key}.vcsh" do
        user node[:user][:user]
        group node[:user][:group]
        command "vcsh write-gitignore #{key.to_s}"
        subscribes :run, resources(:execute => "deploy #{key}.vcsh")
    end
end

execute 'setup vim' do
    user node[:user][:user]
    group node[:user][:group]
    cwd node[:user][:home]
    command 'vim +BundleInstall +qall'
    ignore_failure true
    subscribes :run, resources(:execute => 'deploy vim.vcsh')
end

node[:package][:pip].each do |item|
    execute "pip #{item}" do
        user node[:user][:user]
        group node[:user][:group]
        command "echo pip install --upgrade --force-reinstall #{item}"
        subscribes :run, resources(:execute => 'deploy python.vcsh')
    end
end

node[:package][:gem].each do |item|
    execute "gem #{item}" do
        user node[:user][:user]
        group node[:user][:group]
        command "gem install --user-install #{item}"
        subscribes :run, resources(:execute => 'deploy gem.vcsh')
    end
end


if not node[:package][:npm].empty?
    directory node[:package][:config][:npm][:prefix] do
        owner node[:user][:user]
        group node[:user][:group]
        mode 0600
        action :create
        subscribes :run, resources(:execute => 'deploy npm.vcsh')
    end
end

node[:package][:npm].each do |item|
    execute "npm #{item}" do
        user node[:user][:user]
        group node[:user][:group]
        command "npm_config_prefix=#{node[:package][:config][:npm][:prefix]} npm install -g #{item}"
        subscribes :run, resources(:directory => node[:package][:config][:npm][:prefix])
    end
end

# FIXME: Install node.js by npm n
