terraform {
  required_version = ">= 0.13"
}

resource "nul_resource" "example" {
  # Missing required provisioner
  provisioner "local-exec" {
    # forgotten command
  }
}