locals {

  snyk_auto_import_namespaces = {
    "${local.snyk_squad_email}" = [] # empty means all
  }
  snyk_monitor_gsa = data.google_service_account.snyk_monitor
  snyk_ns          = "${local.tags.team}-tools-snyk"
  snyk_ns_yaml     = <<-EOT
    namespaces:
    - name: ${local.snyk_ns}
      owner: eng-squad-${local.tags.team}@liveramp.com
  EOT
  snyk_squad_id    = "ds-boston"
  snyk_squad_email = "eng-squad-${local.snyk_squad_id}@liveramp.com"

  tags = {
    environment  = "dev"
    team         = "sec-eng"
    region_short = "us"
  }

}
