#############################
# Resource Group
#############################
resource_group_name = "playground"

#############################
# Kubernetes
#############################
cluster_name        = "fr-test-cluster"
kubernetes_version  = "1.14.3"
agent_size          = "Standard_A2_v2"

#############################
# Service Principal for K8s
#############################
client_secret = "test123"
end_date = "2099-01-01T00:00:00Z"
