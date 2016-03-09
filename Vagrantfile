$bootstrap = <<BOOTSTRAP
apt-get update
apt-get install -y nginx
apt-get install -y npm curl
npm install -g n
n 4.3.1
rm /etc/nginx/sites-enabled/*
cp /vagrant/configs/localhost.dev.conf /etc/nginx/sites-enabled/
ln -sf /etc/nginx/sites-enabled/localhost.dev.conf /etc/nginx/sites-available/
(cd /var/www && npm install)
service nginx restart
BOOTSTRAP

$startup = <<STARTUP
node /var/www/server.js &
STARTUP

Vagrant.configure("2") do |config|
	config.vm.box = 'puppetlabs/ubuntu-14.04-64-puppet'

	config.vm.network :forwarded_port, host: 8000, guest: 80
	config.vm.network :forwarded_port, host: 3000, guest: 3000

	config.vm.provider 'virtualbox' do |v|
		v.memory = 1024
		v.cpus   = 2
	end

	config.vm.provision "shell", inline: $bootstrap

	config.vm.synced_folder "./www", "/var/www"

	config.vm.provision "shell", inline: $startup, run: "always", privileged: false

	# owner: "vagrant", group: "www-data"
end
