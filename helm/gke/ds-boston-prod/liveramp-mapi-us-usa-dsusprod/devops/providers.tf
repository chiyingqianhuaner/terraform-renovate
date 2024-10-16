provider "google" {
  project = local.env.project
  region  = local.env.region
}

provider "google-beta" {
  project = local.env.project
  region  = local.env.region
}

provider "vault" {
  address = local.env.vault
}

provider "grafana" {
  url  = local.env.grafana
  auth = data.vault_generic_secret.grafana.data.apikey
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.this.endpoint}"
    token                  = data.google_client_config.this.access_token
    cluster_ca_certificate = base64decode(data.google_container_cluster.this.master_auth[0].cluster_ca_certificate)
  }

  debug = local.helm.debug-option
  experiments {
    manifest = true
  }
}
