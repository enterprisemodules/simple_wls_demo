[![Enterprise Modules](https://raw.githubusercontent.com/enterprisemodules/public_images/master/banner1.jpg)](https://www.enterprisemodules.com)
# Demo Puppet WebLogic implementation

This repo contains a demonstration of a Oracle WebLogic installation. It's purpose is to help you guide through an initial installation of an Oracle WebLogic node with Puppet. This demo is ready for Puppet 4 and for Puppet 5 and Puppet 6.

**Beware**

Puppet 6.14.0 contains a bug the fails the installation. This bug will be fixed in the next release of Puppet. Until then please use Puppet version 6.13.0.

To use a specific version of Puppet use the next variable:

```
export PUPPET_VERSION=6.13.0
```


## WebLogic versions

The demo contains an exampe for WebLogic 12.2.1.2 and an example for WebLogic 12.2.1.3. The nodes for WebLogic 12.2.1.2 are:

- (ml|pe)-wls12212n1 (first node in WebLogic cluster and Admin Server)
- (ml|pe)-wls12212n2 (first node in WebLogic cluster and Admin Server)

For WebLogic 12.2.1.3 the example nodes are:

- (ml|pe)-wls12213n1 (first node in WebLogic cluster and Admin Server)
- (ml|pe)-wls12213n2 (first node in WebLogic cluster and Admin Server)
- ml-wls12213soln1.example.com for a solaris node 

For WebLogic 12.2.1.4 the example nodes are:

- (ml|pe)-wls12214n1 (first node in WebLogic cluster and Admin Server)
- (ml|pe)-wls12214n2 (first node in WebLogic cluster and Admin Server)

For WebLogic 14.1.1.0 the example nodes are:

- (ml|pe)-wls14110n1 (first node in WebLogic cluster and Admin Server)
- (ml|pe)-wls14110n2 (first node in WebLogic cluster and Admin Server)


## Starting the nodes masterless

All nodes are available to test with Puppet masterless. To do so, add `ml-` for the name when using vagrant:

```
$ vagrant up ml-(wls12212n1|wls12212n2|wls12213n1|wls12213n2|wls12214n1|wls12214n2|wls14110n1|wls14110n2)
```

## Starting the nodes with PE

You can also test with a Puppet Enterprise server. To do so, add `pe-` for the name when using vagrant:

```
$ vagrant up pe-wlsmaster
$ vagrant up pe-(wls12212n1|wls12212n2|wls12213n1|wls12213n2|wls12214n1|wls12214n2|wls14110n1|wls14110n2)
```

## ordering

You must always use the specified order:

1. wlmaster
$  wls...n1|wls...n1
$  wls...n2|wls...n2

## Required software

The software must be placed in `modules/software/files`. It must contain the next files: 

For WebLogic 12.2.1.2:
- jdk-8u152-linux-x64.tar.gz
- fmw_12.2.1.2.0_wls.jar
- jce_policy-8.zip

And for WebLogic 12.2.1.3 on Linux:
- jdk-8u152-linux-x64.tar.gz
- fmw_12.2.1.3.0_wls.jar
- jce_policy-8.zip

And for WebLogic 12.2.1.4 on Linux:
- jdk-8u231-linux-x64.tar.gz
- fmw_12.2.1.4.0_wls.jar
- jce_policy-8.zip

And for WebLogic 14.1.1.0 on Linux:
- jdk-8u241-linux-x64.tar.gz
- fmw_14.1.1.0.0_wls.jar
- jce_policy-8.zip

On Solaris you need:
- jdk-8u152-solaris-x64.tar.gz
- fmw_12.2.1.3.0_wls.jar

You can download the file's from [here](http://support.oracle.com)

When you use Puppet Enterprise, you also need puppet-enterprise-2019.1.0-el-7-x86_64.tar.gz and untar it in `modules/software/files`.
