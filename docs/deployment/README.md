# Deployment

## Bootstrap

Receives variables, enables the initial APIs, grants IAM permissions to the Cloud Build service account, and creates the deployment Cloud Build trigger.

1. `cd` into the [bootstrap folder](../../infra/deployment/terraform/bootstrap).
1. Create a [`terraform.tfvars`](https://developer.hashicorp.com/terraform/language/values/variables#variable-definitions-tfvars-files) file and fill out the variables according to your configuration. Leave the `source_repo` variable empty for now.
1. Comment out the contents of the `backend.tf` file.
1. Run `terraform init`.
1. Run `terraform apply -target=module.enable_apis --auto-approve`.
1. Create a [Cloud Source Repository](https://cloud.google.com/source-repositories/docs/creating-an-empty-repository#create_a_new_repository). Update the value of the `sourcerepo_name` variable in the `terraform.tfvars` file.
1. Run `terraform apply --auto-approve`.
1. Uncomment the contents of the `backend.tf` file and add set the `bucket` attribute as the value of the `tfstate_bucket` output.
1. Run `terraform init` and type `yes`.

## Deploy

1. Push to the repository and branch corresponding to the `sourcerepo_name` and `branch_name` bootstrap variables.
