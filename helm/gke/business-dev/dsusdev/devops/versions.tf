terraform {
  required_version = "~> 1.9.0"

  required_providers {
    google      = "~> 4.0"
    google-beta = "~> 4.0"
    vault       = "~> 4.0"
    helm        = "~> 2.16"
    kubernetes  = "~> 2.0"
    grafana = {
      source  = "grafana/grafana"
      version = "~> 2.19"
    }
  }
}

