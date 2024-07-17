provider "google" {
  project = "testing-gcp-ops"
  region  = "us-west1"
  zone    = "us-west1-a"
}

#------------------------------------------(vpc)--------------------------------------------------------------
module "vpc" {
  source                                    = "git::git@github.com:yadavprakash/terraform-gcp-vpc.git?ref=v1.0.0"
  name                                      = "dev"
  environment                               = "test"
  label_order                               = ["name", "environment"]
  mtu                                       = 1460
  routing_mode                              = "REGIONAL"
  google_compute_network_enabled            = true
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
  delete_default_routes_on_create           = false
}

#------------------------------------------(subnet)------------------------------------------------------------
module "subnet" {
  source        = "git::git@github.com:yadavprakash/terraform-gcp-subnet.git?ref=v1.0.0"
  subnet_names  = ["dev-subnet1"]
  name          = "dev"
  environment   = "test"
  label_order   = ["name", "environment"]
  gcp_region    = "us-west1"
  network       = module.vpc.vpc_id
  ip_cidr_range = ["10.10.0.0/16"]
}
#------------------------------------------(firewall)--------------------------------------------------------------
module "firewall" {
  source        = "git::git@github.com:yadavprakash/terraform-gcp-firewall.git?ref=v1.0.0"
  name          = "dev-firewall"
  environment   = "test"
  label_order   = ["name", "environment"]
  network       = module.vpc.vpc_id
  source_ranges = ["0.0.0.0/0"]

  allow = [
    { protocol = "tcp"
      ports    = ["22", "80"]
    }
  ]
}
#------------------------------------------(iap_bastion)--------------------------------------------------------------
module "iap_bastion" {
  source      = "../../"
  name        = "dev"
  environment = "iap-bastion"
  zone        = "us-west1-a"
  network     = module.vpc.self_link
  subnet      = module.subnet.subnet_self_link
  members     = []
}
