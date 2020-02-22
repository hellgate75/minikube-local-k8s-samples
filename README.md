<p align="center">
<image width="100" height="110" src="images/helm-logo.png"></image>&nbsp;
<image width="350" height="350" src="images/kubernetes-logo.png">
&nbsp;<image width="110" height="100" src="images/minikube-logo.png"></image>
</p><br/>
<br/>

# Minikube multi-experience Kubernetes environemnt

Sample code for local installing and running a simple Kubernetes experience.

You can eaily define mutiple profiles and multiple instances. Any folder will remember your profiles, drivers, etc...



## Goals

Fast definition of a Kubernetes study or test environment locally. All commands will be downloaded and installed, in case you do not have them in your system.

In this case you have to source the environment before use this product.



## Requisites

In order to activate the experience you need to have installed:

* Virtualbox (or other minikube suitable Virtualizarion framework)

* Git bash or Linux environment



## How does it work


You can create your machine in a folder just running following command:

* [start-node.sh](/start-node.sh)


You can start/stop/destroy minikube profile, using follwing scripts:

* [start-node.sh](/start-node.sh)

* [stop-node.sh](/stop-node.sh)

* [destroy-node.sh](/destroy-node.sh)


You can check minikube profile using followiung script:

* [node-status.sh](/node-status.sh)

If you in your shell you will run following comamand: 

``` 
	source ./env.sh
```

You will have some commands within already reference of some commands (linked to the folder profile) :

* mk -> minikube -p <profile> .....

* kc -> kubectl .....



Enjoy the experience.



## License

The library is licensed with [LGPL v. 3.0](/LICENSE) clauses, with prior authorization of author before any production or commercial use. Use of this library or any extension is prohibited due to high risk of damages due to improper use. No warranty is provided for improper or unauthorized use of this library or any implementation.

Any request can be prompted to the author [Fabrizio Torelli](https://www.linkedin.com/in/fabriziotorelli) at the follwoing email address:

[hellgate75@gmail.com](mailto:hellgate75@gmail.com)



