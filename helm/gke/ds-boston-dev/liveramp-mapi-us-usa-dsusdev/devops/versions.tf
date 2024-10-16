terraform {
  required_version = "~> 1.1.1"

  required_providers {
    google      = "~> 4.0"
    google-beta = "~> 2.0"
    vault       = "~> 2.0"
    helm        = "~> 2.0"
    kubernetes  = "~> 2.0"
    grafana = {
      source  = "grafana/grafana"
      version = "~> 1.3"
    }
  }
}
