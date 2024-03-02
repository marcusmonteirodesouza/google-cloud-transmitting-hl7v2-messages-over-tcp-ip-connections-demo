resource "google_cloudbuild_trigger" "deploy" {
  name        = "deploy"
  description = "Build and deploy the system - ${var.sourcerepo_name}/${var.branch_name} push"
  location    = "global"

  trigger_template {
    repo_name   = var.sourcerepo_name
    branch_name = var.branch_name
  }

  filename = "infra/deployment/cloudbuild/deploy/cloudbuild.yaml"

  substitutions = {
    _TFSTATE_BUCKET            = var.tfstate_bucket
    _MY_VPN_GATEWAY_IP_ADDRESS = var.my_vpn_gateway_ip_address
  }
}