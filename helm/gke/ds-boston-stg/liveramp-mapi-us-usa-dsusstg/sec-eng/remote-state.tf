

##
##  NOTE: For remote state, you must duplicate this block in your own group directory, BUT THE
##        PREFIX MUST BE MODIFIED.  The form of the prefix is:
##
##            <team>/clusters/cluster_name
##
##        for example,
##
##            prefix = devops/clusters/mttn-internal-dev-01
##
##        Although state buckets are versioned, please avoid writing to a state file prefix that
##        already exists.

terraform {
  backend "gcs" {
    bucket = "ds-boston-dev-terraform-state"
    # format is <team>/clusters/cluster-name
    prefix = "sec-eng/cluster/liveramp-mapi-us-usa-dsusdev"
  }
}


