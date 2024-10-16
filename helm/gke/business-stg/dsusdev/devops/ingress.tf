
module "emissary_svc" {
  source = "../../../../_common/modules/helm-release"

  release = {
    name       = "emissary-svc"
    repository = "https://www.getambassador.io"
    chart      = "emissary-ingress"
    version    = "8.7.0"
  }

}


