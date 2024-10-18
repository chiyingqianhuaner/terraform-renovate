terraform {
  required_version = "~> 1.9.0"

  required_providers {
    google      = "~> 4.85"
    google-beta = "~> 4.85"
    vault       = "~> 4.4"
    helm        = "~> 1.3"
    kubernetes  = "~> 2.33"
    grafana = {
      source  = "grafana/grafana"
      version = "~> 1.43"
    }
  }
}

