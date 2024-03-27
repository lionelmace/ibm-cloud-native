# Retrieve images
# ibmcloud is images | grep ibm-windows-server-2022 | grep "available"
variable "image_name" {
  type        = string
  default     = "ibm-windows-server-2022-full-standard-amd64-11"
  description = "Windows Server 2022"
}

variable "profile_name" {
  type        = string
  description = "Instance profile to use for the private instance"
  default     = "cx2-2x4"
  # default     = "bx2-2x8"
}

##############################################################################

data "ibm_is_image" "image" {
  name = var.image_name
}

resource "tls_private_key" "rsa_4096_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.rsa_4096_key.private_key_pem
  filename        = "rsakey.pem"
  file_permission = "0600"
}

# Generate an SSH Key
resource "ibm_is_ssh_key" "generated_ssh_key" {
  name           = "${local.basename}-ssh-key"
  resource_group = ibm_resource_group.group.id
  public_key     = tls_private_key.rsa_4096_key.public_key_openssh
}

# Create a VSI (Virtual Server Instance)
resource "ibm_is_instance" "vsi-server" {
  name           = "${local.basename}-vsi-server"
  vpc            = ibm_is_vpc.vpc.id
  zone           = ibm_is_subnet.subnet[0].zone
  profile        = var.profile_name
  image          = data.ibm_is_image.image.id
  keys           = [ibm_is_ssh_key.generated_ssh_key.id]
  resource_group = ibm_resource_group.group.id
  tags           = var.tags

  primary_network_interface {
    subnet = ibm_is_subnet.subnet[0].id
  }

  boot_volume {
    name = "${local.basename}-boot"
  }
}

# Create a VSI (Virtual Server Instance)
resource "ibm_is_instance" "vsi-client" {
  name           = "${local.basename}-vsi-client"
  vpc            = ibm_is_vpc.vpc.id
  zone           = ibm_is_subnet.subnet[0].zone
  profile        = var.profile_name
  image          = data.ibm_is_image.image.id
  keys           = [ibm_is_ssh_key.generated_ssh_key.id]
  resource_group = ibm_resource_group.group.id
  tags           = var.tags

  primary_network_interface {
    subnet = ibm_is_subnet.subnet[0].id
  }

  boot_volume {
    name = "${local.basename}-boot"
  }
}