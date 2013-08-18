require_package = %w(
    sudo
    zsh
)

require_package.each do |package_name|
    package package_name do
        action :install
    end
end

group 'czchen' do
end

user 'czchen' do
    home '/home/czchen'
    gid 'czchen'
    shell '/bin/zsh'
end

group 'sudo' do
    action :modify
    members 'czchen'
    append true
end
