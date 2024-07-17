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

#------------------------------------------(service-account)--------------------------------------------------------------
module "service-account" {
  source                             = "git::git@github.com:yadavprakash/terraform-gcp-Service-account.git?ref=v1.0.0"
  name                               = "dev"
  environment                        = "test"
  google_service_account_key_enabled = true
  key_algorithm                      = "KEY_ALG_RSA_2048"
  public_key_type                    = "TYPE_X509_PEM_FILE"
  private_key_type                   = "TYPE_GOOGLE_CREDENTIALS_FILE"
  members                            = []
}

#------------------------------------------(instance_template)--------------------------------------------------------------
module "instance_template" {
  source               = "git::git@github.com:yadavprakash/terraform-gcp-vm-template-instance.git?ref=v1.0.0"
  name                 = "dev"
  environment          = "test"
  region               = "us-west1"
  source_image         = "ubuntu-2204-jammy-v20230908"
  source_image_family  = "ubuntu-2204-lts"
  source_image_project = "ubuntu-os-cloud"
  disk_size_gb         = "20"
  subnetwork           = module.subnet.subnet_id
  instance_template    = true
  service_account      = null
  ## public IP if enable_public_ip is true
  enable_public_ip = true
  metadata = {
    ssh-keys = <<EOF
      dev:ssh-rsa AAAAB3NzaC1yc2EAA/3mwt2y+PDQMU= ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCx9HrdPJD7zv9SJlAKlssHr2CUSvifRBy+bRp2jRvP851p8RiMshlbrkaRAJV7gh0AFAxL6S7znWzGwFQZFv/XP9fEqD8B7XEOtVIZK+99AYRZfkO62WG5BR6vmN1u3ei2zHSY2IuCmita27BOaimfUCXFdPMUMXwKoTMvThK6UVKaoa+IWR7qkG0b7ByLKZBTsCgBlXH4xLkZsFdCsEDWog4ZJcY5F2tPwZkHoqI0g45CcJMlsfC1KMOkN0MLPAR/iR/wfsQ9Zp0GGFwAn3uJXrcAjUGv1/+giw7RYEnmR3PA5CpzuTNJrnNI2KoFUmh7HSRt5atNg0AEj+043I7B23/yKNBaiqqaNSiv5/qO29n1eSkDhQ7l2sLxAcMS3PkTMKcsf89KkqHDt8AEBWUuCPwVTrsSwAF1Fcfj4Fe4LQUYogM5d+Y3u95LdaaCizM8i/RJ0R6aR//OLtvlHeGJFVjSPiazVJea8ZvR+4nO4b67ic6YZvwfVCEUw+ttbb0= kamal@kamal
    EOF
  }
}

resource "google_compute_instance_from_template" "vm" {
  name                     = "dev-example-instance"
  project                  = "testing-gcp-ops"
  zone                     = "us-west1-a"
  source_instance_template = module.instance_template.self_link_unique
  network_interface {
    subnetwork = module.subnet.subnet_self_link
  }
}

resource "google_service_account_iam_binding" "sa_user" {
  service_account_id = module.service-account.account_id
  role               = "roles/iam.serviceAccountUser"
  members            = []
}

resource "google_project_iam_member" "os_login_bindings" {
  for_each = toset([])
  project  = "testing-gcp-ops"
  role     = "roles/compute.osLogin"
  member   = each.key
}

#------------------------------------------(iap_tunneling)--------------------------------------------------------------
module "iap_tunneling" {
  source           = "../../modules/iap-tunneling"
  name             = "dev"
  environment      = "iap-tunneling"
  network          = module.vpc.self_link
  members          = []
  service_accounts = [module.service-account.account_email]
  instances = [{
    name = google_compute_instance_from_template.vm.name
    zone = "us-west1-a"
  }]
}
