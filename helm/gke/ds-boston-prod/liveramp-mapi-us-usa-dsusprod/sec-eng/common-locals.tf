locals {
  helm = {
    "debug-option" : true
  }
  env = {
    project = "ds-boston-dev"
    region  = "us-central1"
    yaml_d  = "../../../../_common/yamls"
    vault   = "https://vault.dev.liveramp.net"
  }

  cluster = {
    name     = "liveramp-mapi-us-usa-dsusdev"
    location = "us-central1-b"
  }
}
