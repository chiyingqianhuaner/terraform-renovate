module "honeypot_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "7.5.0"

  region     = "us-central1"
}

module "cloud-storage_template" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "6.2.0"

  region     = "us-central1"
}
