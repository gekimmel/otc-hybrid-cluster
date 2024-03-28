
This is to demonstrate the seamless integration of OTC Private and OTC Public. A compute cluster is created with resources both in OTC Private and OTC Public environments. To achieve this we will execute a single Terraform script utilizing the same modules on both sides.

The resulting architecture will be as follows:

[Hybrid Computing Architecture](res/Hybrid-Computing-Architecture.png)

After the resource creation, an Ansible playbook configures the hosts and sets up the cluster. We will install an IBM Spectrum LSF Cluster in the Community Edition.

## Preliminaries

Before we begin, let's ensure that certain prerequisites are met. We require the following:

- Credentials for an account on an [OTC Private](https://www.open-telekom-cloud.com/de/produkte-services/private-cloud) tenant.
- Credentials for an account on an [OTC Public](https://www.open-telekom-cloud.com/) tenant.
- Installation file lsfsce10.2.0.12-x86_64.tar.gz for the [IBM Spectrum LSF Community Edition](https://www.ibm.com/support/pages/where-do-i-download-lsf-community-edition).
- An administrative Linux host with an internet connection having the Terraform binary and git client installed.

## Workflow

The LSF cluster will be set up following the workflow shown in the diagram below. Steps 1 to 3 are executed on the administrative host.

[Hybrid Computing Architecture Workflow](res/Hybrid-Computing-Architecture-Workflow.png)

1. First, we clone a repository containing the deployment scripts from a Git repository.
2. The [OTC Terraform Provider](https://registry.terraform.io/providers/opentelekomcloud/opentelekomcloud/latest/docs) is used to create the resources in the OTC Private and OTC Public environments.
3. Now we log in to the master host of the cluster.
4. The master host will also serve as an Ansible server to configure all nodes in the cluster.

## Deployment Preparation

Check preliminaries on your administrative host:

```
# check if git client is available (we do not precisely need this version)
[linux@admin-host]$ git --version
git version 1.8.3.1
# check if terraform is available (we do not precisely need this version)
[linux@admin-host]$ terraform -version
Terraform v1.7.4
on linux_amd64
# check available disk space (we need around 2 GB)
[linux@admin-host]$ df -h .
Filesystem      Size  Used Avail Use% Mounted on
/dev/vda1        14G  9.8G  3.4G  75% /
```

Now, obtain a copy of the [IBM Spectrum LSF Community Edition](https://www.ibm.com/support/pages/where-do-i-download-lsf-community-edition) installation tar file. At the time of writing, the file is named lsfsce10.2.0.12-x86_64.tar.gz. You may need to create a free [IBMid](https://www.ibm.com/account/reg/us-en/signup) account first. In your base directory, create another directory called lsf_download and copy the tar file into it. It should now appear as follows:

```
[linux@admin-host]$ ls -lh lsf_download/
total 1.7G
-rw-rwxr--. 1 linux linux 1.7G Jan 24 12:44 lsfsce10.2.0.12-x86_64.tar.gz
```

Clone the Git repository to your local file system

```
[linux@admin-host]$ git clone https://github.com/gekimmel/otc-hybrid-cluster.git
```

Copy the provider.tf file from the template and insert your credentials

```
[linux@admin-host]$ cd otc-hybrid-cluster
[linux@admin-host]$ cp provider.tf-template provider.tf
[linux@admin-host]$ vi provider.tf
->
edit domain_name, tenant_name, user_name, and password for otc_private and otc_public section
<-
```

Generate an SSH key pair (to be used later by the LSF cluster).

```
[linux@admin-host]$ ssh-keygen -f ~/.ssh/id_rsa_lsf -N ""
```

## Infrastructure Deployment

Start the deployment

```
[linux@admin-host]$ terraform init
[linux@admin-host]$ terraform apply
yes
```

Copy the LSF SSH private key to the lsf-master host

```
[linux@admin-host]$ scp -i ~/.ssh/id_rsa_lsf -o StrictHostKeyChecking=no ~/.ssh/id_rsa_lsf linux@$(terraform output | awk '{ print $3 }' | sed 's/"//g'):/home/linux/.ssh/id_rsa
```

Copy the Ansible playbooks to the lsf-master host

```
[linux@admin-host]$ scp -i ~/.ssh/id_rsa_lsf -o StrictHostKeyChecking=no -r ansible linux@$(terraform output | awk '{ print $3 }' | sed 's/"//g'):/home/linux/
```

Copy the LSF Spectrum installation tar file to the lsf-master host

```
[linux@admin-host]$ scp -i ~/.ssh/id_rsa_lsf -o StrictHostKeyChecking=no ../lsf_download/lsfsce10.2.0.12-x86_64.tar.gz linux@$(terraform output | awk '{ print $3 }' | sed 's/"//g'):/data/lsf_download/.
```

Now log in to lsf-master host

```
[linux@admin-host]$ ssh -i ~/.ssh/id_rsa_lsf -o StrictHostKeyChecking=no linux@$(terraform output | awk '{ print $3 }' | sed 's/"//g')
```

## Configure and install the cluster

Apply the [Ansible](https://www.ansible.com/) playbook

```
[linux@lsf-master]$ cd ansible
[linux@lsf-master]$ ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ./hosts lsf_setup.yml
```

[Start and test the cluster](https://www.ibm.com/docs/en/spectrum-lsf/10.1.0?topic=reference)

```
[linux@lsf-master]$ sudo -i
[root@lsf-master]# lsfstartup
[root@lsf-master]# lshosts -w
[root@lsf-master]# bhosts
[root@lsf-master]# bsub -n 28 sleep 60
[root@lsf-master]# bhosts
```

## Summary

Your cluster now comprises 7 hosts: the master host, as well as 3 compute hosts each in OTC Public and OTC Private environments. Jobs are executed and controlled across the different environments through the VPN connection.

The entire infrastructure was created using the same Terraform code on both sides. The provider.tf file contains the credentials for the tenants on OTC Private and OTC Public. The main.tf file references each resource type according to the respective cloud.
 
```
[root@lsf-master ~]# lshosts -w
HOST_NAME                       type       model  cpuf ncpus maxmem maxswp server RESOURCES
lsf-master                    X86_64 Intel_Platinum  15.0     4   3.8G      -    Yes (mg)
lsf-comp-priv-1               X86_64 Intel_Platinum  15.0     4   3.8G      -    Yes ()
lsf-comp-priv-2               X86_64 Intel_Platinum  15.0     4   3.8G      -    Yes ()
lsf-comp-priv-3               X86_64 Intel_Platinum  15.0     4   3.8G      -    Yes ()
lsf-comp-pub-1                X86_64 Intel_Platinum  15.0     4   3.8G      -    Yes ()
lsf-comp-pub-2                X86_64 Intel_Platinum  15.0     4   3.8G      -    Yes ()
lsf-comp-pub-3                X86_64 Intel_Platinum  15.0     4   3.8G      -    Yes ()
[root@lsf-master ~]# bhosts
HOST_NAME          STATUS       JL/U    MAX  NJOBS    RUN  SSUSP  USUSP    RSV
lsf-comp-priv-1    ok              -      4      0      0      0      0      0
lsf-comp-priv-2    ok              -      4      0      0      0      0      0
lsf-comp-priv-3    ok              -      4      0      0      0      0      0
lsf-comp-pub-1     ok              -      4      0      0      0      0      0
lsf-comp-pub-2     ok              -      4      0      0      0      0      0
lsf-comp-pub-3     ok              -      4      0      0      0      0      0
lsf-master         ok              -      4      0      0      0      0      0
[root@lsf-master ~]# bsub -n 28 sleep 60
Job <50> is submitted to default queue <normal>.
[root@lsf-master ~]# bhosts
HOST_NAME          STATUS       JL/U    MAX  NJOBS    RUN  SSUSP  USUSP    RSV
lsf-comp-priv-1    closed          -      4      4      4      0      0      0
lsf-comp-priv-2    closed          -      4      4      4      0      0      0
lsf-comp-priv-3    closed          -      4      4      4      0      0      0
lsf-comp-pub-1     closed          -      4      4      4      0      0      0
lsf-comp-pub-2     closed          -      4      4      4      0      0      0
lsf-comp-pub-3     closed          -      4      4      4      0      0      0
lsf-master         closed          -      4      4      4      0      0      0
```

For more information see [How to build up hybrid workloads for Private and Public Cloud](https://community.open-telekom-cloud.com/community?id=community_blog&sys_id=6c05e1e0b77c4e10d15aa7b16b8c020d).
