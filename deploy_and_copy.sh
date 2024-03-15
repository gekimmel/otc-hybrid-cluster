#!/bin/sh -x
# perform these steps to deply the infrastructure after cloning the scripts from git

# initialize terraform
terraform init

# start the deployment
terraform apply -auto-approve

# give some time for VMs to start
sleep 60

# get EIP of lsf-master
LSFMASTER="$(terraform output | awk '{ print $3 }' | sed 's/"//g')"

# copy private key
scp -i ~/.ssh/id_rsa_lsf -o StrictHostKeyChecking=no ~/.ssh/id_rsa_lsf $LSFMASTER:/home/linux/.ssh/id_rsa

# copy ansible playbooks
scp -i ~/.ssh/id_rsa_lsf -o StrictHostKeyChecking=no -r ansible $LSFMASTER:/home/linux/

# copy LSF Spectrum installation file
scp -i ~/.ssh/id_rsa_lsf -o StrictHostKeyChecking=no ../lsf_download/lsfsce10.2.0.12-x86_64.tar.gz $LSFMASTER:/data/lsf_download/.

echo "now you can login to lsf-master with the following command:"
echo "ssh -i ~/.ssh/id_rsa_lsf $LSFMASTER"
