node.set["apache"]["user"]  = "vagrant"
node.set["apache"]["group"] = "vagrant"

node.set['mysql']['server_root_password']   = "root"
node.set['mysql']['server_debian_password'] = "root"
node.set['mysql']['server_repl_password']   = "root"

node.set['mysql']['bind_address']      = node[:app][:ip]
node.set['mysql']['allow_remote_root'] = "1";

include_recipe "apt"
include_recipe "networking_basic"

package "python-software-properties"
execute "add-apt-repository ppa:zanfur/php5.5"

execute "/usr/bin/apt-get update"

include_recipe "php"
include_recipe "apache2"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_headers"
include_recipe "apache2::mod_expires"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_deflate"
include_recipe "apache2::mod_filter"
include_recipe "mysql"
include_recipe "mysql::server"
include_recipe "composer"

package "git-core"
package "make"
package "vim"
package "php-pear" do
    action :upgrade
end
package "php5-cli"
package "php5-fpm"
package "php5-cgi"
package "php5-dev"
package "php5-curl"
package "php5-gd"
package "php5-intl"
package "php5-mcrypt"
package "php5-mysql"
package "php5-sqlite"
package "php5-tidy"
package "php5-xmlrpc"
package "php5-xsl"
package "libpcre3-dev"
#include_recipe "php::module_apc"

include_recipe "phpunit"

php_pear "xdebug" do
  action :install
end

git "cphalcon" do
  repository "git://github.com/phalcon/cphalcon.git"
end

execute "compile cphalcon" do
  command "./install"
  cwd "/cphalcon/build"
  notifies :restart, "service[apache2]"
end

# gem_package "less"
# gem_package "sass"
# gem_package "compass"

execute "/bin/rm /etc/apache2/sites-enabled/* -Rf"
execute "/bin/rm /etc/apache2/sites-available/* -Rf"

node[:app][:web_apps].each do |identifier, app|
  web_app identifier do
    server_name app[:server_name]
    server_aliases app[:server_aliases]
    docroot app[:guest_docroot]
    php_timezone app[:php_timezone]
  end
end

template "#{node['php']['ext_conf_dir']}/xdebug.ini" do
  source "xdebug.ini.erb"
  owner "root"
  group "root"
  mode "0644"
end

template "#{node['php']['ext_conf_dir']}/cphalcon.ini" do
  source "cphalcon.ini.erb"
  owner "root"
  group "root"
  mode "0644"
end

template "#{node['php']['ext_conf_dir']}/opcache.ini" do
  source "opcache.ini.erb"
  owner "root"
  group "root"
  mode "0644"
end

execute "/bin/rm /usr/bin/phalcon -Rf"
execute "/bin/ln -s /vagrant/www/phalcon/phalcon.php /usr/bin/phalcon"
execute "/bin/chmod ugo+x /usr/bin/phalcon"
