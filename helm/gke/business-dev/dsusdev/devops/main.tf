module "honeypot_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "10.1.1"

  region     = "us-central1"
}