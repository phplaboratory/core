#!/bin/bash
mkdir /opt/bin
pushd /opt/bin
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
popd
chmod +x /opt/bin/kubectl
ln -s /opt/bin/kubectl /usr/local/bin/kubectl
sudo curl -o /usr/local/bin/docker-compose -L "https://github.com/docker/compose/releases/download/1.8.1/docker-compose-$(uname -s)-$(uname -m)"
sudo chmod +x /usr/local/bin/docker-compose

mkdir -p /opt/kubernetes/
chmod +x /opt/madcore/kubernetes/kubernetes_generate_ssl.sh
/opt/madcore/kubernetes/kubernetes_generate_ssl.sh

pushd /opt/madcore/kubernetes/
    cp docker-compose.service /etc/systemd/system/docker-compose-kubernetes.service
    cp docker-compose.yml.template  /opt/kubernetes/docker-compose.yml
    cp -R manifests /opt/kubernetes
    cp -R addons /opt/kubernetes
    cp -R ssl /opt/kubernetes
popd

# systemd reload
sudo systemctl daemon-reload

# Enable the service
pushd /etc/systemd/system/
    sudo systemctl enable docker-compose-kubernetes.service
popd

# Start the service
systemctl start docker-compose-kubernetes

# wait kubernetes api
echo "waiting kubernetes api...."
sleep 10
api_ready="false"
until [[ $api_ready != "running" ]]; do
api_reary=$(kubectl get pods --all-namespaces | grep api | awk '{print $4}')
done
sleep 30
echo "kubernetes api server is ready"
# Start dashboard and dns

kubectl create -f /opt/kubernetes/addons
