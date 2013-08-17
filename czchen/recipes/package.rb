package_list = %w(
    build-essential
    git
    manpages
    manpages-dev
    manpages-posix
    manpages-posix-dev
    vim-gnome
    zsh
)

package_list.each do |package_name|
    package package_name do
        action :install
    end
end
