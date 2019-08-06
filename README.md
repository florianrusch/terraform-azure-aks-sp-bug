# Terraform Azure - AKS + SP Bug

## Quick start

```shell
$ terraform init
$ terraform apply -var-file="test.tfvars"
...
$ terraform destroy -var-file="test.tfvars"
```

## Error

```
azuread_application.sp: Creating...
azuread_application.sp: Still creating... [10s elapsed]
azuread_application.sp: Creation complete after 10s [id=xxx-2e4d13319e6b]
azuread_application_password.sp: Creating...
azurerm_kubernetes_cluster.k8s: Creating...
azuread_application_password.sp: Still creating... [10s elapsed]
azurerm_kubernetes_cluster.k8s: Still creating... [10s elapsed]
azuread_application_password.sp: Creation complete after 10s [id=xxx-2e4d13319e6b/f6d9a925-2b6c-26a3-c78a-44b62335e753]

Error: Error creating/updating Managed Kubernetes Cluster "fr-test-cluster" (Resource Group "playground"): containerservice.ManagedClustersClient#CreateOrUpdate: Failure sending request: StatusCode=400 -- Original Error: Code="ServicePrincipalNotFound" Message="Internal server error"

  on main.tf line 73, in resource "azurerm_kubernetes_cluster" "k8s":
  73: resource "azurerm_kubernetes_cluster" "k8s" {
```
