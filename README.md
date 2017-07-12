# Configuration

## Host

```
$ lsb_release -a
Distributor ID:	Ubuntu
Description:	Ubuntu 16.04.2 LTS
Release:	16.04
Codename:	xenial
```

## Vagrant

```
$ vagrant --version
Vagrant 1.9.5

$ vagrant plugin install vagrant-vbguest
Installed the plugin 'vagrant-vbguest (0.14.2)'
```

## Python

```
$ python --version
Python 2.7.12
```

## Pip

```
git+ssh://git@github.com/metacloud/molecule.git@master
python-vagrant==0.5.15
yamllint==1.8.1
```

# Initial commits:

1. `make new-molecule-role`
2. Replace `image: centos:7` by `box: bento/centos-7.3` in `molecule/default/molecule.yml`

# Reproduce the issue:
1. `make test`


Failure message:

```
Bringing machine 'instance' up with 'virtualbox' provider...
==> instance: Preparing master VM for linked clones...
    instance: This is a one time operation. Once the master VM is prepared,
    instance: it will be used as a base for linked clones, making the creation
    instance: of new VMs take milliseconds on a modern system.
==> instance: Importing base box 'bento/centos-7.3'...
Progress: 20%
Progress: 30%
Progress: 50%
Progress: 70%
Progress: 90%
==> instance: Cloning VM...
==> instance: Matching MAC address for NAT networking...
==> instance: Checking if box 'bento/centos-7.3' is up to date...
==> instance: Setting the name of the VM: molecule_instance_1499846363830_65126
==> instance: Clearing any previously set network interfaces...
==> instance: Preparing network interfaces based on configuration...
    instance: Adapter 1: nat
==> instance: Forwarding ports...
    instance: 22 (guest) => 2222 (host) (adapter 1)
==> instance: Running 'pre-boot' VM customizations...
==> instance: Booting VM...
==> instance: Waiting for machine to boot. This may take a few minutes...
    instance: SSH address: 127.0.0.1:2222
        instance: SSH username: vagrant
        instance: SSH auth method: private key
        instance: Warning: Remote connection disconnect. Retrying...
        instance: 
        instance: Vagrant insecure key detected. Vagrant will automatically replace
        instance: this with a newly generated keypair for better security.
        instance: 
        instance: Inserting generated public key within guest...
        instance: Removing insecure key from the guest if it's present...
        instance: Key inserted! Disconnecting and reconnecting using new SSH key...
==> instance: Machine booted and ready!
[instance] GuestAdditions 5.1.22 running --- OK.
==> instance: Checking for guest additions in VM...
==> instance: Setting hostname...
==> instance: Mounting shared folders...
    instance: /vagrant => /home/cyrille/code/Deployment/ansible-role-foo/molecule/default/.molecule
==> instance: Machine not provisioned because `--no-provision` is specified.

{
    "IdentityFile": "/home/cyrille/code/Deployment/ansible-role-foo/molecule/default/.molecule/.vagrant/machines/instance/virtualbox/private_key",
    "changed": true, 
    "LogLevel": "FATAL", 
    "HostName": "127.0.0.1",
    "Host": "instance",
    "PasswordAuthentication": "no",
    "IdentitiesOnly": "yes",
    "UserKnownHostsFile": "/dev/null",
    "User": "vagrant",
    "invocation": {
        "module_args": {
            "platform_box_url": null,
            "provider_cpus": 2,
            "provider_raw_config_args": null,
            "platform_box": "bento/centos-7.3",
            "state": "up",
            "instance_interfaces": [],
            "instance_name": "instance",
            "platform_box_version": null,
            "provider_memory": 512,
            "instance_raw_config_args": null,
            "provider_options": {},
            "provider_name": "virtualbox",
            "force_stop": false
        },
        "StrictHostKeyChecking": "no",
        "Port": "2222"
    }",
    "msg": "MODULE FAILURE",
    "rc": 0
}


```

# Workaround the issue:

1. Remove `when: server.changed | bool` conditions in `molecule/default/create.yml`
2. make workaround (call `molecule create` twice)