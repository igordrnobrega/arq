default['postgres']['user']                    = "postgres"
default['postgres']['group']                   = "postgres"
default['postgres']['service']                 = "postgres"

# Start Postgres service on installation
default['postgres']['start_service']           = true

include_recipe "apt"
include_recipe "networking_basic"

package "python-software-properties"
execute "add-apt-repository ppa:zanfur/php5.5"

execute "/usr/bin/apt-get update"

include_recipe "php"
include_recipe "build-essential::default"
include_recipe "ohai"
include_recipe "nginx"
include_recipe "postgres::client"
include_recipe "postgres::server"
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
