module "honeypot_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "7.5.0"

  region     = "us-central1"
}

module "cloud-storage_template" {
  source  = "terraform-google-modules/cloud-storage/google"
  version = "4.2.0"

  region     = "us-central1"
}

module "project-factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "13.0.0"
  # insert the 2 required variables here
}
