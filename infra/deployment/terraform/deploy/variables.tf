variable "project_id" {
  type        = string
  description = "The project ID."
}

variable "my_vpn_gateway_ip_address" {
  type        = string
  description = "IP address of the interface in the external VPN gateway. Only IPv4 is supported. This IP address can be either from your on-premise gateway or another Cloud provider's VPN gateway, it cannot be an IP address from Google Compute Engine."
}