resource "openstack_compute_instance_v2" "bootstrap" {
  name            = "bootstrap"
  image_name      = "CentOS 7.6"
  flavor_name     = "saveloy"
  key_pair        = "${var.ssh_key_pair}"
  user_data       = "${file("user-data.conf")}"
  security_groups = ["dcos"]

  network {
    uuid           = "${openstack_networking_network_v2.private.id}"
    fixed_ip_v4    = "10.0.0.5"
    access_network = true
  }
}

resource "openstack_networking_floatingip_v2" "bootstrap_external_ip" {
  pool       = "internet"
  depends_on = ["openstack_networking_router_interface_v2.dcos_router_int"]
}

resource "openstack_compute_floatingip_associate_v2" "bootstrap_external_ip" {
  floating_ip = "${openstack_networking_floatingip_v2.bootstrap_external_ip.address}"
  instance_id = "${openstack_compute_instance_v2.bootstrap.id}"

  provisioner "file" {
    connection {
      type = "ssh"
      host = "${openstack_networking_floatingip_v2.bootstrap_external_ip.address}"
      user = "centos"
    }
    source      = "${path.module}/setup.sh"
    destination = "/tmp/setup.sh"
  }

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = "${openstack_networking_floatingip_v2.bootstrap_external_ip.address}"
      user = "centos"
    }

    inline = ["sh /tmp/setup.sh > /tmp/setup.log"]
  }
}

resource "openstack_compute_instance_v2" "master" {
  count           = "${var.number_of_masters}"
  name            = "master${count.index}"
  image_name      = "CentOS 7.6"
  flavor_name     = "cumberland"
  key_pair        = "${var.ssh_key_pair}"
  security_groups = ["dcos"]
  user_data       = "${file("user-data.conf")}"

  network {
    uuid        = "${openstack_networking_network_v2.private.id}"
    fixed_ip_v4 = "10.0.0.10${count.index}"
  }

  provisioner "file" {
    connection {
      type         = "ssh"
      host         = "10.0.0.10${count.index}"
      user         = "centos"
      bastion_host = "${openstack_networking_floatingip_v2.bootstrap_external_ip.address}"
      bastion_user = "centos"
    }
    
    source      = "${path.module}/setup.sh"
    destination = "/tmp/setup.sh"
  }
  
  provisioner "remote-exec" {
    connection {
      type         = "ssh"
      host         = "10.0.0.10${count.index}"
      user         = "centos"
      bastion_host = "${openstack_networking_floatingip_v2.bootstrap_external_ip.address}"
      bastion_user = "centos"
    }
    
    inline = ["sudo sh /tmp/setup.sh > /tmp/setup.log"]
  }
}

resource "openstack_networking_floatingip_v2" "master_external_ip" {
  pool       = "internet"
  depends_on = ["openstack_networking_router_interface_v2.dcos_router_int"]
}

resource "openstack_compute_floatingip_associate_v2" "master_external_ip" {
  floating_ip = "${openstack_networking_floatingip_v2.master_external_ip.address}"
  instance_id = "${openstack_compute_instance_v2.master.id}"
}

resource "openstack_compute_instance_v2" "public0" {
  count           = "1"
  name            = "public0"
  image_name      = "CentOS 7.6"
  flavor_name     = "saveloy"
  key_pair        = "${var.ssh_key_pair}"
  security_groups = ["dcos"]
  user_data       = "${file("user-data.conf")}"

  network {
    uuid        = "${openstack_networking_network_v2.private.id}"
    fixed_ip_v4 = "10.0.0.150"
  }
  provisioner "file" {
    connection {
      type         = "ssh"
      host         = "10.0.0.15${count.index}"
      user         = "centos"
      bastion_host = "${openstack_networking_floatingip_v2.bootstrap_external_ip.address}"
      bastion_user = "centos"
    }
    
    source      = "${path.module}/setup.sh"
    destination = "/tmp/setup.sh"
  }
  
  provisioner "remote-exec" {
    connection {
      type         = "ssh"
      host         = "10.0.0.15${count.index}"
      user         = "centos"
      bastion_host = "${openstack_networking_floatingip_v2.bootstrap_external_ip.address}"
      bastion_user = "centos"
    }
    
    inline = ["sudo sh /tmp/setup.sh > /tmp/setup.log"]
  }
}

resource "openstack_networking_floatingip_v2" "public_agent_external_ip" {
  pool       = "internet"
  depends_on = ["openstack_networking_router_interface_v2.dcos_router_int"]
}

resource "openstack_compute_floatingip_associate_v2" "public_agent_external_ip" {
  floating_ip = "${openstack_networking_floatingip_v2.public_agent_external_ip.address}"
  instance_id = "${openstack_compute_instance_v2.public0.id}"
}

resource "openstack_compute_instance_v2" "private" {
  count           = "5"
  name            = "private${count.index}"
  image_name      = "CentOS 7.6"
  flavor_name     = "saveloy"
  key_pair        = "${var.ssh_key_pair}"
  security_groups = ["dcos"]
  user_data       = "${file("user-data.conf")}"

  network {
    uuid        = "${openstack_networking_network_v2.private.id}"
    fixed_ip_v4 = "10.0.0.20${count.index}"
  }
  provisioner "file" {
    connection {
      type         = "ssh"
      host         = "10.0.0.20${count.index}"
      user         = "centos"
      bastion_host = "${openstack_networking_floatingip_v2.bootstrap_external_ip.address}"
      bastion_user = "centos"
    }
    
    source      = "${path.module}/setup.sh"
    destination = "/tmp/setup.sh"
  }
  
  provisioner "remote-exec" {
    connection {
      type         = "ssh"
      host         = "10.0.0.20${count.index}"
      user         = "centos"
      bastion_host = "${openstack_networking_floatingip_v2.bootstrap_external_ip.address}"
      bastion_user = "centos"
    }
    
    inline = ["sudo sh /tmp/setup.sh > /tmp/setup.log"]
  }
}
