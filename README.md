Requerimientos
------------
* VirtualBox <http://www.virtualbox.org>
* Vagrant <http://www.vagrantup.com>
* Git <http://git-scm.com/>


### Startup
	$ git clone https://github.com/rad8329/vagrant-lapp.git
	$ cd vagrant-lapp
	$ vagrant up

#### Apache
El servidor Apache estará habiltado en <http://localhost:8788> o por la dirección IP 192.168.7.7

#### MySQL
Externamente el servidor MySQL estará habiliatdo por el puerto 8889, e internamente en la VM estará habilitado en el puerto usual 3306  o por socket.

`Username:` root
`Password:` root

#### Redis

Externamente el servidor Redis estará habiliatdo por el puerto 8790, e internamente en la VM estará habilitado en el puerto usual 6379.

Detalles técnicos
-----------------
* Ubuntu 16.04.01 64-bit
* Apache 2
* PHP 7.0 + Composer
* PostgreSQL 9.5
* Redis 3.0.6
* Beanstalkd 1.10

La carpeta `www` será nuestro `documentRoot`.

Para acceder a la VM, lo podrá hacer así

	$ vagrant ssh
