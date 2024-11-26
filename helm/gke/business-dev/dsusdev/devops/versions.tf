terraform {
  required_version = "~> 1.9.8"

  required_providers {
    google      = "~> 3.90"
    google-beta = "~> 3.90"
    vault       = "~> 2.24"
    helm        = "~> 1.3"
    kubernetes  = "~> 2.34"
    grafana = {
      source  = "grafana/grafana"
      version = "~> 2.19"
    }
  }
}
