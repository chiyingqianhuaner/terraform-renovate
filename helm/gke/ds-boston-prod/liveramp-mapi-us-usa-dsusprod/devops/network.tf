resource "google_compute_ssl_policy" "modern_tls" {
  name            = "modern-tls-12"
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"
}

### static external ip for a unified ingress ###
resource "google_compute_global_address" "emissary_external_ingress" {
  name    = "emissary-external-ingress"
  project = data.google_project.this.project_id
}
