
module "emissary_svc" {
  source = "../../../../_common/modules/helm-release"

  release = {
    name       = "emissary-svc"
    repository = "https://www.getambassador.io"
    chart      = "emissary-ingress"
    version    = "8.7.0"
  }
  opts = module.helm_init.opts

  values = [
    templatefile("${local.env.yaml_d}/emissary-svc.yaml.tmpl", local.emissary_svc_map)
  ]

}


