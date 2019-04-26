[![Enterprise Modules](https://raw.githubusercontent.com/enterprisemodules/public_images/master/banner1.jpg)](https://www.enterprisemodules.com)
# Demo Puppet WebLogic implementation

This repo contains a demonstration of a Oracle WebLogic installation. It's purpose is to help you guide through an initial installation of an Oracle WebLogic node with Puppet. This demo is ready for Puppet 4 and for Puppet 5.

## Starting the nodes masterless

All nodes are available to test with Puppet masterless. To do so, add `ml-` for the name when using vagrant:

```
$ vagrant up ml-wls1
```

## Staring the nodes with PE

You can also test with a Puppet Enterprise server. To do so, add `pe-` for the name when using vagrant:

```
$ vagrant up pe-wlsmaster
$ vagrant up pe-wls1
```

## ordering

You must always use the specified order:

1. wlmaster
2. wls01
2. wls02

## Required software

The software must be placed in `modules/software/files`. It must contain the next files:

## Vagrant plugins

Below are two required vagrant plugins to perform the setup build:

- vagrant-triggers
- vagrant-vbguest

### Puppet Enterprise
- puppet-enterprise-2018.1.3-el-7-x86_64-x86_64.tar.gz (Extracted tar)

### JDK 1.5.2
- jdk-8u152-linux-x64.tar.gz

### Oracle WebLogic 12.2.1.2
- fmw_12.2.1.3.0_wls.jar

### Jce Policy 8
- jce_policy-8.zip

You can download this file from
[here](http://support.oracle.com)
