####################
# Create A Cluster #
####################

# Open Docker Preferences, select the Kubernetes tab, and select the "Enable Kubernetes" checkbox

# Open Docker Preferences, select the Advanced tab, set CPUs to 4, and Memory to 4.0

# Make sure that your current kubectl context is pointing to your Docker for Mac/Windows cluster

###################
# Install Ingress #
###################

kubectl apply -f \
    https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml

kubectl apply -f \
    https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml

##################
# Install Tiller #
##################

kubectl create \
    -f https://raw.githubusercontent.com/vfarcic/k8s-specs/master/helm/tiller-rbac.yml \
    --record --save-config

helm init --service-account tiller

kubectl -n kube-system \
    rollout status deploy tiller-deploy

##################
# Get Cluster IP #
##################

LB_IP=[...] # Replace with the IP of the cluster obtainer with `ifconfig`

#######################
# Destroy the cluster #
#######################

# Reset Kubernetes cluster
