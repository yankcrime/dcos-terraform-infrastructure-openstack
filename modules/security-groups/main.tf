locals {
  public_agents_additional_ports = "${concat(list("80","443"),var.public_agents_additional_ports)}"
}

resource "openstack_compute_secgroup_v2" "internal" {
  name        = "dcos-${var.cluster_name}-internal-firewall"
  description = "Allow all internal traffic"

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "udp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "public_agents" {
  name        = "dcos-${var.cluster_name}-public-agents-lb-firewall"
  description = "Allow incoming traffic on Public Agents load balancer"

  count = "${length(local.public_agents_additional_ports)}"

  rule {
    ip_protocol = "tcp"
    from_port   = "${element(local.public_agents_additional_ports, count.index)}"
    to_port     = "${element(local.public_agents_additional_ports, count.index)}"
    cidr        = "${var.public_agents_access_ips}"
  }
}

resource "openstack_compute_secgroup_v2" "master_lb" {
  name        = "dcos-${var.cluster_name}-master-lb-firewall"
  description = "Allow incoming traffic on masters load balancer"

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "${var.admin_ips}"
  }

  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "${var.admin_ips}"
  }
}
