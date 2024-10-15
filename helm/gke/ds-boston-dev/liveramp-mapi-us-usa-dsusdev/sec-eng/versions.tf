terraform {
  required_version = "~> 1.0"

  required_providers {
    google      = "~> 6.0"
    google-beta = "~> 6.0"
    vault       = "~> 4.0"
    helm        = "~> 2.0"
    kubernetes  = "~> 2.0"
    grafana = {
      source  = "grafana/grafana"
      version = "~> 3.0"
    }
  }
}
