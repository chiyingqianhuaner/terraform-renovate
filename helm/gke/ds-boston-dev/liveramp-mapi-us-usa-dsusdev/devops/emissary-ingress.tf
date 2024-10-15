locals {

  emissary_ns = "emissary-system"

  emissary_svc_map = {
    replicaCount  = 2
    minReplicas   = 2
    maxReplicas   = 3
    canaryEnabled = true
    crdsCreate    = false
    crdsKeep      = true
  }

  emissary_ns_yaml = <<-EOT
    namespaces:
    - name: ${local.emissary_ns}
      owner: eng-squad-ops@liveramp.com
  EOT

  emissary_secret_yaml = <<-EOT
    kubeSecrets:
    - name: emissary-ingress-webhook-ca
      type: kubernetes.io/tls
      data:
      - key: tls.crt
        value: ${base64encode(data.vault_generic_secret.emissary_apiext.data.crt)}
        b64enc: false
      - key: tls.key
        value: ${base64encode(data.vault_generic_secret.emissary_apiext.data.key)}
        b64enc: false
  EOT

  emissary_config_yaml = <<-EOF
     hostsEnabled: true
     hosts:
     - name: star-dev-liveramp-com
       spec:
         hostname: '*.dev.liveramp.com'
         requestPolicy:
           insecure:
             action: Redirect
     mappingsEnabled: true
     mappings:
     - name: external-echo-http
       spec:
         hostname: echo-boston.dev.liveramp.com
         prefix: /
         service: echo-debug-http-echo.http-echo:8080
   EOF

  shadow_service_yaml = <<-EOF
    shadowService:
      shadows:
      - name: open
        iap:
          enabled: false
        securityPolicy:
          enabled: false
  EOF

  ext_ingress_map = {
    staticIpName  = google_compute_global_address.emissary_external_ingress.name
    sslPolicyName = google_compute_ssl_policy.modern_tls.name
  }

  ext_ingress_host_routing_yaml = <<-EOT
    ingress:
      backend:
        virtualHostsEnabled: true
        virtualHosts:
        - hostNames:
          - '*.dev.liveramp.com'
          serviceName: open-shadow-service
          servicePort: 80
  EOT
  ext_ingress_manual_cert_yaml  = <<-EOT
    ingress:
      manualCertificate:
        enabled: true
        domains:
        - name: wildcard-dev-liveramp-com
          crt: ${base64encode(module.cert.star_dev_liveramp_com.data.crt-bundle)}
          key: ${base64encode(module.cert.star_dev_liveramp_com.data.key)}
  EOT
  #
  #  # this boolean value is here to allow us to split the installation of emissary CRDs from the charts
  #  # that use them. On pass 1 this value should be false, on 2-n it should be true
  emissary_crds_installed = true
}

module "emissary_ns" {
  source = "../../../../_common/modules/helm-release"

  release = {
    name       = "emissary-ns"
    namespace  = "kube-system"
    repository = "gs://charts-liveramp-net/infra/stable"
    chart      = "user-namespaces"
    version    = "1.1.2"
  }
  opts = module.helm_init.opts

  values = [local.emissary_ns_yaml]

  depends_on = [
    module.helm_init
  ]
}

module "emissary_secret" {
  source = "../../../../_common/modules/helm-release"

  release = {
    name       = "emissary-ca-secret"
    namespace  = local.emissary_ns
    repository = "gs://charts-liveramp-net/infra/stable"
    chart      = "secrets"
    version    = "1.2.0"
  }
  opts = module.helm_init.opts

  values = [local.emissary_secret_yaml]

  depends_on = [
    module.emissary_ns
  ]
}

module "emissary_crds" {
  source = "../../../../_common/modules/helm-release"

  release = {
    name       = "emissary-crds"
    namespace  = local.emissary_ns
    repository = "gs://charts-liveramp-net/infra/stable"
    chart      = "emissary-crds"
    version    = "3.3.0"
  }
  opts = module.helm_init.opts

  values = []

  depends_on = [
    module.emissary_secret,
    module.emissary_ns
  ]
}

module "emissary_svc" {
  source = "../../../../_common/modules/helm-release"
  count  = local.emissary_crds_installed ? 1 : 0

  release = {
    name       = "emissary-svc"
    namespace  = local.emissary_ns
    repository = "https://www.getambassador.io"
    chart      = "emissary-ingress"
    version    = "8.7.0"
  }
  opts = module.helm_init.opts

  values = [
    templatefile("${local.env.yaml_d}/emissary-svc.yaml.tmpl", local.emissary_svc_map)
  ]

  depends_on = [
    module.emissary_ns
  ]
}

module "emissary_config" {
  source = "../../../../_common/modules/helm-release"

  count = local.emissary_crds_installed == true ? 1 : 0

  release = {
    name       = "emissary-config"
    namespace  = local.emissary_ns
    repository = "gs://charts-liveramp-net/infra/stable"
    chart      = "emissary-config"
    version    = "0.1.1"
  }
  opts = module.helm_init.opts

  values = [
    file("${local.env.yaml_d}/emissary-listener-behind-l7.yaml.tmpl"),
    local.emissary_config_yaml
  ]

  depends_on = [
    module.emissary_svc
  ]
}

module "emissary_shadows" {
  source = "../../../../_common/modules/helm-release"

  release = {
    name       = "emissary-shadows"
    namespace  = local.emissary_ns
    repository = "gs://charts-liveramp-net/infra/stable"
    chart      = "shadow-service"
    version    = "0.5.0"
  }
  opts = module.helm_init.opts

  values = [
    file("${local.env.yaml_d}/emissary-shadow-service-origin.yaml.tmpl"),
    local.shadow_service_yaml,
  ]

  depends_on = [
    module.emissary_svc
  ]
}

module "emissary_external_ingress" {
  source = "../../../../_common/modules/helm-release"

  release = {
    name       = "emissary-external-ingress"
    namespace  = local.emissary_ns
    repository = "gs://charts-liveramp-net/infra/stable"
    chart      = "gke-ingress"
    version    = "0.5.3"
  }
  opts = module.helm_init.opts

  values = [
    templatefile("${local.env.yaml_d}/external-ingress-header.yaml.tmpl", local.ext_ingress_map),
    local.ext_ingress_host_routing_yaml,
    local.ext_ingress_manual_cert_yaml,
    templatefile("${local.env.yaml_d}/external-ingress-ssl-policy.yaml.tmpl", local.ext_ingress_map),
  ]

  depends_on = [
    module.emissary_shadows
  ]
}
