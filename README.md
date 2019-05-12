[![Enterprise Modules](https://raw.githubusercontent.com/enterprisemodules/public_images/master/banner1.jpg)](https://www.enterprisemodules.com)
# Demo Puppet WebLogic implementation

This repo contains a demonstration of a Oracle WebLogic installation. It's purpose is to help you guide through an initial installation of an Oracle WebLogic node with Puppet. This demo is ready for Puppet 4 and for Puppet 5 and Puppet 6.

## WebLogic versions

The demo contains an exampe for WebLogic 12.2.1.2 and an example for WebLogic 12.2.1.3. The nodes for WebLogic 12.2.1.2 are:

- (ml|pe)-wls12212n1 (first node in WebLogic cluster and Admin Server)
- (ml|pe)-wls12212n2 (first node in WebLogic cluster and Admin Server)

For WebLogic 12.2.1.3 the example nodes are:

- (ml|pe)-wls12213n1 (first node in WebLogic cluster and Admin Server)
- (ml|pe)-wls12213n2 (first node in WebLogic cluster and Admin Server)

## Starting the nodes masterless

All nodes are available to test with Puppet masterless. To do so, add `ml-` for the name when using vagrant:

```
$ vagrant up ml-(wls12212n1|wls12212n2|wls12213n1|wls12213n2)
```

## Starting the nodes with PE

You can also test with a Puppet Enterprise server. To do so, add `pe-` for the name when using vagrant:

```
$ vagrant up pe-wlsmaster
$ vagrant up pe-(wls12212n1|wls12212n2|wls12213n1|wls12213n2)
```

## ordering

You must always use the specified order:

1. wlmaster
$  wls12212n1|wls12213n1
$  wls12212n2|wls12213n2

## Required software

The software must be placed in `modules/software/files`. It must contain the next files: 

For WebLogic 12.2.1.2:
- jdk-8u152-linux-x64.tar.gz
- fmw_12.2.1.2.0_wls.jar
- jce_policy-8.zip

And for WebLogic 12.2.1.3:
- jdk-8u152-linux-x64.tar.gz
- fmw_12.2.1.3.0_wls.jar
- jce_policy-8.zip

You can download the file's from [here](http://support.oracle.com)

When you use Puppet Enterprise, you also need puppet-enterprise-2019.1.0-el-7-x86_64.tar.gz and untar it in `modules/software/files`.
