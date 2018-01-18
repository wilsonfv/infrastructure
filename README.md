# Introdution
This project aims to build a personal [wordpress](https://wordpress.com) on a cloud server. It runs some shell scripts to push some packages and puppet code to the cloud server.Once the puppet agent is installed on the cloud server, all infrastruture changes needed for a wordpress to run, such as nginx, php, mysql, wordpress etc will be automated installed by the puppet code. Then a personal wordpress website will be available on the cloud server.<br>
Infrastructure as code, this project will use vagrant to start up a local linux server where you can test all your infrastructure changes before push to cloud.

# Prerequisite
* Development environment should be mac. If you are using Windows, you need to install bash environment, such as [Cygwin](https://www.cygwin.com)
* Install [vagrant](https://www.vagrantup.com)
* Install [virtual box](https://www.virtualbox.org)
* A cloud server, I use [Alibaba Cloud](https://www.alibabacloud.com). Though you can test all the infrastructure on your local vagrant box without a cloud server.

# Project Structure
#### Package
Yum repo and mysql config etc

#### Puppet
Puppet code to build infracstructure. It is a stand alone puppet agent design. Once the puppet agent is installed on the linux server (whether its the local vagrant linux server or the cloud linux server), [puppet apply](https://puppet.com/docs/puppet/4.10/man/apply.html) will run then apply all the changes to the server.

#### Script
Shell script to push the puppet code and repo packges to the server

#### Server
common.yaml.serverName is to store the wordpress website config. The config.serverName is to store your cloud server ip and ssh port.

#### vagrant_centos
The vagrant file to boot up a linux server on your local machine

# Development
```shell
./server_bootstrap.sh vagrantbox
```
This will boot up a local linux centos box and initial all the infrastructure changes then you can access the wordpress website on your local [localhost:8080/blog](localhost:8080/blog)

