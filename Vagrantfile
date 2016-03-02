# -*- mode: ruby -*-
# vi: set ft=ruby :

php_timezone_cli = "America/Sao_Paulo"
guest_project_folder = "/vagrant/www"

web_apps = {
  "localhost" => {
    "host_project_folder"  => "www",
    "guest_docroot"        => "/vagrant/www",
    "guest_project_folder" => "/vagrant/www",
    "server_name"          => "localhost",
    "server_aliases"       => ["localhost"],
    "php_timezone"         => "America/Sao_Paulo"
  },
}

Vagrant.configure("2") do |config|
  config.vm.box     = "App.Precise32.Php5"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.network :forwarded_port, guest: 80, host: 80
  config.vm.network :forwarded_port, guest: 3306, host: 3306
  # config.vm.network :forwarded_port, guest: 9000, host: 9000

  web_apps.each do |id, web_app|
    config.vm.synced_folder web_app['host_project_folder'], guest_project_folder
  end

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file precise32.pp in the manifests_path directory.

  # config.vm.provision :puppet do |puppet|
  #     puppet.manifests_path = "./manifests"
  #     puppet.module_path    = "./modules"
  #     puppet.manifest_file  = "base.pp"
  # end

  config.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = "./cookbooks"
      chef.add_recipe "vagrant_main"
      #You may also specify custom JSON attributes:
      chef.json = {
        "app" => {
          "web_apps"             => web_apps,
          "php_timezone_cli"     => php_timezone_cli,
          "guest_project_folder" => guest_project_folder
        }
        #:mysql_password => "foo"
      }
  end
end
