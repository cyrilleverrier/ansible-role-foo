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
2. Replace `image: centos:7` by `box: centos/7` in `molecule/default/molecule.yml`

# Reproduce the issue:
1. `make test`


# Workaround the issue:

1. Remove `when: server.changed | bool` conditions in `molecule/default/create.yml`
2. make workaround (call `molecule create` twice)