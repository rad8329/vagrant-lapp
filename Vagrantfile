require 'json'
require 'yaml'

VAGRANTFILE_API_VERSION = "2"

config_vagrant = File.expand_path("./config.yaml")

require_relative 'scripts/php7config.rb'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
    config.vm.provision "shell", path: "scripts/customize.sh"

    Php7Config.configure(config, YAML::load(File.read(config_vagrant)))
end
