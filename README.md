# Infrastructure_as_a_Code
Ansible code challenge

## What the playbook does

The `Vagrantfile` allows you to:

- Deploy two CentOS 8 VMs
- Run the ansible playbook `playbook.yml`
  - Create and mount a 40GiB partition
  - Install and setup Docker
  - Exposes the docker daemon APIs securely
  - Create and setup a Docker Swarm
  - Run a nginx test service on the Swarm Manager with two replicas
- Run a serverspec test

## Prerequisites

- ansible
- ruby
- vagrant
  - vagrant-hostsupdater plugin
  - vagrant-disksize plugin
  - vagrant-serverspec plugin
- virtualbox
- molecule
- pip

## Molecule Test

Install `yamllint` and `ansible-lint`

You can submit a molecule test to the `ansible-role-partition` role with the following commands:

```
cd roles/ansible-role-partition
molecule test
```
This repository provides CI using Github actions that lint the code and run the `ansible-role-partition` molecule test.

## How to deploy

### Setup

Generate an RSA SSH key pair with the following command:

`$ ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa -q`

Add this code to your `~/.ssh/config` file in order to handle vms in a more convenient way:

```
# For vagrant virtual machines
Host 192.168.33.* *.code-challenge
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
  User root
  LogLevel ERROR
```

Because of these lines (https://max.engineer/six-ansible-practices#build-a-convenient-local-playground):

- SSH won’t complain about non-matching keys for your ever-changing vagrant VMs
- SSH won’t try to remember and manage those keys via `~/.ssh/known_hosts`
- You won’t have to specify `root@…` every time
- SSH won't show warnings we are aware of

Install vagrant plugins:

`$ vagrant plugin install vagrant-disksize vagrant-hostsupdater vagrant-serverspec`

Install `jmespath` with pip:

`$ pip install jmespath==0.9.3`

### Run the code

`$ vagrant up`

## Connect to a VM

You can connect to your docker instances with secured connection:

`$ docker --tlsverify --tlscacert=certs/ca/ca.pem --tlscert=certs/client/client-cert.pem --tlskey=certs/client/client-key.pem -H {IP}:2376 info`

with {IP}=192.168.77.21 (Swarm manager) or {IP}=192.168.77.22 (Swarm worker).

## Test the deployed service

Type http://192.168.77.21:80 or http://192.168.77.22:80 on your browser and you would see the NGINX server running.
