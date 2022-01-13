locals {
  vpn_router_name_prefix = var.vpn_router_name_prefix == "" ? "" : "${var.vpn_router_name_prefix}-"
}

# HA VPN
module "vpn_ha_1" {
  source     = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version    = "~> 2.1.0"
  project_id = var.project_id
  region     = var.location
  network    = google_compute_network.private_pool_vpc.self_link
  name       = "${local.vpn_router_name_prefix}cloudbuild-to-${var.gke_network}"
  router_asn = var.vpn_gateway_1_asn
  router_advertise_config = {
    ip_ranges = {
      var.workerpool_range = "Cloud Build Private Pool"
    }
    mode   = "CUSTOM"
    groups = ["ALL_SUBNETS"]
  }
  peer_gcp_gateway = "https://compute.googleapis.com/compute/v1/projects/${var.gke_project}/regions/${var.gke_location}/vpnGateways/${local.vpn_router_name_prefix}${var.gke_network}-to-cloudbuild"
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = cidrhost(var.bgp_range_1, 2) # 169.254.1.2
        asn     = var.vpn_gateway_2_asn
      }
      bgp_peer_options                = null
      bgp_session_range               = var.bgp_range_1 # 169.254.1.1/30 
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }
    remote-1 = {
      bgp_peer = {
        address = cidrhost(var.bgp_range_2, 2) #"169.254.2.2"
        asn     = var.vpn_gateway_2_asn
      }
      bgp_peer_options                = null
      bgp_session_range               = var.bgp_range_2 # 169.254.2.1/30 
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }
  }
}

module "vpn_ha_2" {
  count = length(var.gke_networks)

  source     = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version    = "~> 1.3.0"
  project_id = var.gke_project
  region     = var.gke_location
  network    = var.gke_network
  name       = "${local.vpn_router_name_prefix}${var.gke_network}-to-cloudbuild"
  router_asn = var.vpn_gateway_2_asn
  router_advertise_config = {
    ip_ranges = var.gke_control_plane_cidrs
    mode      = "CUSTOM"
    groups    = ["ALL_SUBNETS"]
  }
  peer_gcp_gateway = "https://compute.googleapis.com/compute/v1/projects/${var.project_id}/regions/${var.location}/vpnGateways/${local.vpn_router_name_prefix}cloudbuild-to-${var.gke_network}"
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = cidrhost(var.bgp_range_1, 1) # 169.254.1.1
        asn     = var.vpn_gateway_1_asn
      }
      bgp_peer_options                = null
      bgp_session_range               = var.bgp_range_1 # 169.254.1.2/30
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = module.vpn_ha_1.random_secret
    }
    remote-1 = {
      bgp_peer = {
        address = cidrhost(var.bgp_range_2, 1) # 169.254.2.1
        asn     = var.vpn_gateway_1_asn
      }
      bgp_peer_options                = null
      bgp_session_range               = var.bgp_range_1 # 169.254.2.2/30
      ike_version                     = 2
      vpn_gateway_interface           = 1
      peer_external_gateway_interface = null
      shared_secret                   = module.vpn_ha_1.random_secret
    }
  }
}