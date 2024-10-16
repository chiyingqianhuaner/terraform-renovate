module "snyk_ns" {
  source = "../../../../_common/modules/helm-release"

  release = {
    name       = local.snyk_ns
    namespace  = "kube-system"
    repository = "gs://charts-liveramp-net/infra/stable"
    chart      = "user-namespaces"
    version    = "1.1.2"
  }
  opts = module.helm_init.opts

  values = [local.snyk_ns_yaml]
}

module "snyk" {
  source = "../../../../_common/modules/snyk"

  cluster = {
    name     = local.cluster.name
    location = local.env.region
    project  = local.env.project
  }
  env                              = local.env
  helm_init_opts                   = module.helm_init.opts
  snyk_monitor_gsa_email           = local.snyk_monitor_gsa.email
  snyk_ns                          = local.snyk_ns
  snyk_sa_token                    = data.vault_generic_secret.snyk_monitor.data.token
  tenant_namespaces_by_squad_email = local.snyk_auto_import_namespaces

  depends_on = [
    module.snyk_ns,
  ]
}
