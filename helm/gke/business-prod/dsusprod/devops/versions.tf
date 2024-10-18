terraform {
  required_version = "~> 1.0.0"

  required_providers {
    google      = "~> 3.0"
    google-beta = "~> 3.0"
    vault       = "~> 4.0"
    helm        = "~> 1.0"
    kubernetes  = "~> 2.0"
    grafana = {
      source  = "grafana/grafana"
      version = "~> 1.3"
    }
  }
}
