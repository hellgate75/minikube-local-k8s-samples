<p align="center">
<image width="100" height="110" src="images/helm-logo.png"></image>&nbsp;
<image width="350" height="350" src="images/kubernetes-logo.png">
&nbsp;<image width="110" height="100" src="images/minikube-logo.png"></image>
</p><br/>
<br/>

# Minikube multi-experience Kubernetes environemnt : Flow-Centric Experience

Sample toolset used for local installation, management and run of a single server Kubernetes cluster experience with easy multiple profiles definition, mainteinance and management

You can eaily define mutiple profiles and multiple instances. Any folder will remember your profiles, drivers, etc...

Working folder contains binaries, tools and configuration files used to run the commands and the Kubernetes experience. Using multiple working folders you can maintain multiple peofiles, nodes and Kunernetes clusters.



## Goals

Fast definition of a Kubernetes study or test environment locally. All commands will be downloaded and installed, in case you do not have them in your system.

In this case you have to source the environment before use this product.



## Requisites

In order to activate the experience you need to have installed:

* Virtualbox (or other minikube suitable Virtualizarion framework, see here: [specifying-the-vm-driver](https://kubernetes.io/docs/setup/learning-environment/minikube/#specifying-the-vm-driver) or here [minikube-drivers](https://minikube.sigs.k8s.io/docs/reference/drivers/) )

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


You can check create, check, and provide help infomration for Kubernetes API available components, using following script (--help for command usage and various options):

* [help.sh](/help.sh)


You can add and remove the Kubernetes dashboard, using following command (use "--delete" to remove the dashboard) :

* [install-show-dashboard.sh](/install-show-dashboard.sh)

(It needs kubectl and at least one profile created, run it in the project folder you created the Kubernetes cluster)


In order to set binary installation folder in your shell you can run following comamand: 

``` 
	source ./env.sh
```

You will have some commands within already reference of some commands (linked to the folder profile) :

* mk -> minikube -p <profile> .....

* kc -> kubectl .....



## Install Flow-Centric

In order to install flow-centric environment, please run following script file (after your virtual machine is ready and you have required the environment in the shell):

* [install-flow-centric-packages.sh](/install-flow-centric-packages.sh)




## Available tools

Here list of available tools:

* minikube (used to init/manage Kubernetes cluster)

* kubectl (used to control Kubernetes cluster)

* helm (used to deploy charts)

* kops (used to manage cluster and Kubernetes components)

* kind (creates and manages local Kubernetes clusters using Docker container 'nodes')


Enjoy the experience.



## License

The library is licensed with [LGPL v. 3.0](/LICENSE) clauses, with prior authorization of author before any production or commercial use. Use of this library or any extension is prohibited due to high risk of damages due to improper use. No warranty is provided for improper or unauthorized use of this library or any implementation.

Any request can be prompted to the author [Fabrizio Torelli](https://www.linkedin.com/in/fabriziotorelli) at the follwoing email address:

[hellgate75@gmail.com](mailto:hellgate75@gmail.com)



