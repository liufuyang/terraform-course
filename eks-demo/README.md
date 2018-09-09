# Setting up AWS EKS (Hosted Kubernetes)

See https://www.terraform.io/docs/providers/aws/guides/eks-getting-started.html for full guide

If you following the code here, you can try follow the steps bellow:

## Setting up your terraform config

1. Copy this repo to your local directory, and cd into this folder
2. `mv terraform.tfvars.examples terraform.tfvars` and edit it with your AWS keys.
3. Before continuing, make sure you have create a new user (other than the
  root user of your AWS account) in IAM, giving it enough permissions.
  For simplicity you can just assign `AdministratorAccess` to the group this user
  belongs to. With more detailed permissions, you will have to be sure you also have
  `AmazonEKSClusterPolicy` and `AmazonEKSServicePolicy` for this user.

## Download kubectl
```
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x kubectl
ln -s $(pwd)/kubectl /usr/local/bin/kubectl
```

## Download the aws-iam-authenticator
```
wget https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.3.0/heptio-authenticator-aws_0.3.0_linux_amd64
chmod +x heptio-authenticator-aws_0.3.0_linux_amd64

ln -s $(pwd)/heptio-authenticator-aws_0.3.0_linux_amd64 /usr/local/bin/heptio-authenticator-aws
```

## Modify providers.tf

Choose your region. EKS is not available in every region, use the Region Table to check whether your region is supported: https://aws.amazon.com/about-aws/global-infrastructure/regional-product-services/

Make changes in providers.tf accordingly (region, optionally profile)

## Terraform apply
```
terrafomr init
terraform apply
```

## Configure kubectl
```
mkdir .config
terraform output kubeconfig > .config/ekskubeconfig # save output in ~/.kube/config or use the following env prarm

export  KUBECONFIG=$KUBECONFIG:$(pwd)/.config/ekskubeconfig
```

## Configure config-map-auth-aws
```
terraform output config-map-aws-auth > .config/config-map-aws-auth.yaml # save output in config-map-aws-auth.yaml

kubectl apply -f .config/config-map-aws-auth.yaml
```

## See nodes coming up
```
kubectl get nodes
```

More info [here](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html)

## Deploy the Dashboard

More info [here](https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html).

### Step 1: Deploy the Dashboard

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml
```

### Step 2: Create an eks-admin Service Account and Cluster Role Binding

```
kubectl apply -f eks-admin-service-account.yaml
kubectl apply -f eks-admin-cluster-role-binding.yaml
```

### Step 3: Connect to the Dashboard
```
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')

kubectl proxy
```

Then open http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

And use the token output from previous command to login.


## Destroy
Make sure all the resources created by Kubernetes are removed (LoadBalancers, Security groups), and issue:
```
terraform destroy
```
