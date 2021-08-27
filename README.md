### Start dari 0 

* Jika membuat dari local machine, maka credential di terraform/terraform.tf disesuaikan dengan direktori lokal.
* Jika membuat dari jenkins, maka ganti dengan "./creds/serviceaccount.json"

* Pastikan back-end gcs nya fresh.
* Sesuaikan nama di terraform/variables.tf dan terraform/module/*/variables.tf --> untuk final diset devops-telkomsel-7

### Terraform
cd terraform
terraform init
terraform plan
terraform apply

### Ansible
Prerequisite : set IP VM yg baru dibuat di file ansible/inventory/hosts

cd ../ansible/
ansible -m ping all
ansible-playbook -i inventory/hosts playbook/install-java-playbook.yml
ansible-playbook -i inventory/hosts playbook/install-jenkins-playbook.yml


### Setup Jenkins
buka browser http://[IP_VM]:8080 dan ikuti instruksi

install plugin :
-	Plugin: Blue Ocean
-	Plugin: Kubernetes CLI
-	Plugin: docker-build-step
-	Plugin: docker pipeline

sudo groupadd docker
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

Manage Credential :
- Dockerhub
- SA key (json)
- SA key (secret text)
- Github account

### Buat new multibranch pipeline

