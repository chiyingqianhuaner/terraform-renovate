data "google_project" "this" {
  project_id = local.env.project
}

data "google_client_config" "this" {}

data "google_container_cluster" "this" {
  name     = local.cluster.name
  location = local.cluster.location
  project  = data.google_project.this.project_id
}

data "vault_generic_secret" "emissary_apiext" {
  path = "secret/applications/certificates/emissary-apiext-ca"
}

data "google_compute_default_service_account" "default" {
}

data "vault_generic_secret" "snyk_monitor" {
  path = "secret/security/snyk/${local.snyk_squad_id}-snyk-monitor-sa"
}