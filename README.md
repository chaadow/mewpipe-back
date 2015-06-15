# 1. Getting started

## 1.1 - Requirements

Please download and install the following software :

* [VirtualBox](https://www.virtualbox.org),

* [Vagrant](http://vagrantup.com).


## 1.2 - How To Build The Virtual Machine

Building the virtual machine is this easy:

    cd /destination/to/your/code
    vagrant up

Launching the packaged webserver is not too complicated neither :

	vagrant ssh
	cd /vagrant
	foremant start

Congratulations ! You can now connect to your local version of **Mepipe** :

	open http://api.mewpipe.com:5000
