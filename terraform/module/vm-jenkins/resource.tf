resource "google_compute_instance" "devops7-instance-1" {
  name         = "${var.name}-instance-1"
  machine_type = var.machine_type

  tags = ["${var.name}-jenkins-server"]

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  metadata_startup_script = <<EOT
    #!/bin/bash
    //sudo apt install nginx -y
    //sudo systemctl start nginx
    
    //install k8s
    sudo apt-get update
    sudo apt-get install -y apt transport https curl
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
    sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl
    kubectl completion bash >> .bashrc
    source .bashrc

    //install gcloud
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    sudo apt-get install apt-transport-https ca-certificates gnupg
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    sudo apt-get update && sudo apt-get install google-cloud-sdk
    sudo apt-get install google-cloud-sdk-app-engine-python
    sudo apt-get install google-cloud-sdk-app-engine-python-extras
    sudo apt-get install kubectl

    //install terraform
    wget https://releases.hashicorp.com/terraform/1.0.5/terraform_1.0.5_linux_amd64.zip
    sudo apt install unzip
    unzip terraform_1.0.5_linux_amd64.zip
    sudo mv terraform /usr/local/bin/
    rm terraform_1.0.5_linux_amd64.zip

    //install Docker
    sudo apt-get update -y
    sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update -y
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y
    sudo docker run hello-world
    sudo groupadd docker
    sudo usermod -aG docker $USER
    
EOT

  network_interface {
    # network = google_compute_network.devops7-vpc.self_link
    # subnetwork = google_compute_subnetwork.devops7-subnet.self_link   
    network = "${var.name}-vpc"
    subnetwork = "${var.name}-subnet" 
    access_config {
       network_tier = "STANDARD"
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.PATH_TO_PUBLIC_KEY)}"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file(var.PATH_TO_PRIVATE_KEY)
    host = coalesce(self.network_interface[0].access_config[0].nat_ip)
  }
}

