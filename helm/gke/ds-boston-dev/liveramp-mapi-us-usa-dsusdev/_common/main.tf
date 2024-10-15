module "helm_init" {
  source = "../../../../_common/modules/helm-initialize"

  opts = {
    atomic            = "true"
    timeout           = 600
    dependency_update = "true"
  }
}

module "cert" {
  source = "git@github.com:LiveRamp/infrastructure.git//_modules/cert/dev"
}
