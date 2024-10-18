module "honeypot_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "7.5.0"

  region     = "us-central1"
}

module "honeypot_template_02" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "7.2.0"

  region     = "us-central1"
}