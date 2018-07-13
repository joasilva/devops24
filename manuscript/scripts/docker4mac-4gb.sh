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
# Install ChartMuseum #
#######################

CM_ADDR="cm.$LB_IP.nip.io"

echo $CM_ADDR

CM_ADDR_ESC=$(echo $CM_ADDR \
    | sed -e "s@\.@\\\.@g")

echo $CM_ADDR_ESC

helm install stable/chartmuseum \
    --namespace charts \
    --name cm \
    --values helm/chartmuseum-values.yml \
    --set ingress.hosts."$CM_ADDR_ESC"={"/"} \
    --set env.secret.BASIC_AUTH_USER=admin \
    --set env.secret.BASIC_AUTH_PASS=admin

kubectl -n charts \
    rollout status deploy \
    cm-chartmuseum

curl "http://$CM_ADDR/health" # It should return `{"healthy":true}`

#######################
# Destroy the cluster #
#######################

# Reset Kubernetes cluster
