module "honeypot_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "12.0.0"

  region     = "us-central1"
}