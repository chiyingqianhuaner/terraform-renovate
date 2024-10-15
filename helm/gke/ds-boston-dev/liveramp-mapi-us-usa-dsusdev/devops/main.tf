module "helm_init" {
  source = "../../../../_common/modules/helm-initialize"

  opts = {
    atomic            = "true"
    timeout           = 600
    dependency_update = "true"
  }
}

module "cert" {
  source = "git@github.com:LiveRamp/infrastructure.git//_modules/cert/dev"
}

module "honeypot_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "12.0.0"

  region     = "us-central1"
  project_id = local.env.project

  subnetwork         = "eng-ops-canary-honeypot-dev-usc1"

  source_image_family  = "thinkst-canary"
  source_image_project = "thinkst-canary-5a6d1666f17f4e7"

}