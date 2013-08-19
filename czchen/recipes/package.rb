package_list = %w(
    build-essential
    manpages
    manpages-dev
    manpages-posix
    manpages-posix-dev
)

package_list.each do |package_name|
    package package_name do
        action :install
    end
end
