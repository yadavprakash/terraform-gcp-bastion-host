# Terraform-google-bastion-host
# Terraform Google Cloud bastion-host Module
## Table of Contents

## Table of Contents
- [Introduction](#introduction)
- [Usage](#usage)
- [Module Inputs](#module-inputs)
- [Module Outputs](#module-outputs)
- [Authors](#authors)
- [License](#license)

## Introduction
This project deploys a Google Cloud infrastructure using Terraform to create bastion .

## Usage

To use this module, you should have Terraform installed and configured for GCP. This module provides the necessary Terraform configuration for creating GCP resources, and you can customize the inputs as needed. Below is an example of how to use this module:
# Example: bastion-host

```hcl
module "iap_bastion" {
  source      = "https://github.com/yadavprakash/terraform-gcp-bastion-host.git"
  name        = "dev"
  environment = "iap-bastion"
  zone        = "us-west1-a"
  network     = module.vpc.self_link
  subnet      = module.subnet.subnet_self_link
  members     = []
}
```

This example demonstrates how to create various GCP resources using the provided modules. Adjust the input values to suit your specific requirements.

## Module Inputs

- `name`: The name of the application or resource.
- `environment`: The environment in which the resource exists.
- `label_order`: The order in which labels should be applied.
- `business_unit`: The business unit associated with the application.
- `attributes`: Additional attributes to add to the labels.
- `extra_tags`: Extra tags to associate with the resource.

## Module Outputs
- This module currently does not provide any outputs.

# Examples
For detailed examples on how to use this module, please refer to the [example](https://github.com/yadavprakash/terraform-gcp-bastion-host/tree/master/_example) directory within this repository.

## Authors
Your Name
Replace '[License Name]' and '[Your Name]' with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/yadavprakash/terraform-gcp-bastion-host/blob/master/LICENSE) file for details.



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.53, < 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.53, < 5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iap_tunneling"></a> [iap\_tunneling](#module\_iap\_tunneling) | ./modules/iap-tunneling | n/a |
| <a name="module_instance_template"></a> [instance\_template](#module\_instance\_template) | git::git@github.com:yadavprakash/terraform-gcp-vm-template-instance.git | v1.0.0 |
| <a name="module_labels"></a> [labels](#module\_labels) | git::git@github.com:yadavprakash/terraform-gcp-labels.git | v1.0.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_instance_from_template.bastion_vm](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance_from_template) | resource |
| [google_project_iam_custom_role.compute_os_login_viewer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_custom_role) | resource |
| [google_project_iam_member.bastion_oslogin_bindings](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.bastion_sa_bindings](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.bastion_host](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_binding.bastion_sa_user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |
| [random_id.random_role_id_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [google_client_config.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_ports"></a> [additional\_ports](#input\_additional\_ports) | A list of additional ports/ranges to open access to on the instances from IAP. | `list(string)` | `[]` | no |
| <a name="input_create_firewall_rule"></a> [create\_firewall\_rule](#input\_create\_firewall\_rule) | If we need to create the firewall rule or not. | `bool` | `true` | no |
| <a name="input_create_instance_from_template"></a> [create\_instance\_from\_template](#input\_create\_instance\_from\_template) | Whether to create and instance from the template or not. If false, no instance is created, but the instance template is created and usable by a MIG | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_image_family"></a> [image\_family](#input\_image\_family) | Source image family for the Bastion. | `string` | `"ubuntu-2204-lts"` | no |
| <a name="input_image_project"></a> [image\_project](#input\_image\_project) | Project where the source image for the Bastion comes from | `string` | `"ubuntu-os-cloud"` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. sequence of application name and environment `name`,`environment`,'attribute' [`webserver`,`qa`,`devops`,`public`,] . | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Key-value map of labels to assign to the bastion host | `map(any)` | `{}` | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, eg yadavprakash. | `string` | `""` | no |
| <a name="input_members"></a> [members](#input\_members) | List of IAM resources to allow access to the bastion host | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the resource. Provided by the client when the resource is created. | `string` | `"test"` | no |
| <a name="input_network"></a> [network](#input\_network) | Self link for the network on which the Bastion should live | `string` | `""` | no |
| <a name="input_random_role_id"></a> [random\_role\_id](#input\_random\_role\_id) | Enables role random id generation. | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where the bastion instance template will live | `string` | `"us-west1"` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Terraform current module repo | `string` | `"https://github.com/yadavprakash/terraform-gcp-bastion-host.git"` | no |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | If set, the service account and its permissions will not be created. The service account being passed in should have at least the roles listed in the `service_account_roles` variable so that logging and OS Login work as expected. | `string` | `""` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Account ID for the service account | `string` | `"bastion"` | no |
| <a name="input_service_account_roles"></a> [service\_account\_roles](#input\_service\_account\_roles) | List of IAM roles to assign to the service account. | `list(string)` | <pre>[<br>  "roles/logging.logWriter",<br>  "roles/monitoring.metricWriter",<br>  "roles/monitoring.viewer",<br>  "roles/compute.osLogin"<br>]</pre> | no |
| <a name="input_service_account_roles_supplemental"></a> [service\_account\_roles\_supplemental](#input\_service\_account\_roles\_supplemental) | An additional list of roles to assign to the bastion if desired | `list(string)` | `[]` | no |
| <a name="input_ssh-keys"></a> [ssh-keys](#input\_ssh-keys) | n/a | `string` | `""` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | Self link for the subnet on which the Bastion should live. Can be private when using IAP | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | The primary zone where the bastion host will live | `string` | `"us-west1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_hostname"></a> [hostname](#output\_hostname) | Host name of the bastion |
| <a name="output_instance_template"></a> [instance\_template](#output\_instance\_template) | Self link of the bastion instance template for use with a MIG |
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | Internal IP address of the bastion host |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | Self link of the bastion host |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | The email for the service account created for the bastion host |
<!-- END_TF_DOCS -->