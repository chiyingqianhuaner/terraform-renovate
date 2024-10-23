terraform {
  required_version = "~> 1.0.0"

  required_providers {
    google      = "~> 6.0"
    google-beta = "~> 6.0"
    vault       = "~> 2.0"
    helm        = "~> 1.0"
    kubernetes  = "~> 2.0"
    grafana = {
      source  = "grafana/grafana"
      version = "~> 2.0"
    }
  }
}
