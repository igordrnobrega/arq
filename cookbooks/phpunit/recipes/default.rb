include_recipe 'php'

execute 'pear config-set auto_discover 1'

channels = %w{pear.phpunit.de pear.symfony.com components.ez.no}
channels.each do |chan|
  php_pear_channel chan do
    action [:discover, :update]
  end
end

php_pear 'PEAR' do
  cur_version = `pear -V| head -1| awk -F': ' '{print $2}'`
  action :upgrade
  not_if { Gem::Version.new(cur_version) > Gem::Version.new('1.9.0') }
end

php_pear 'PHPUnit' do
  channel 'phpunit'
  action :install
end
