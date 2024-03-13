## apply ansible playbook to configure the cluster
``` 
[linux@lsf-master]$ ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ./hosts lsf_setup.yml
``` 
## start and test the cluster
``` 
[linux@lsf-master]$ sudo -i
[root@lsf-master]# lsfstartup
[root@lsf-master]# lshosts
[root@lsf-master]# bhosts
[root@lsf-master]# bsub -n 28 sleep 60
[root@lsf-master]# bhosts
``` 
