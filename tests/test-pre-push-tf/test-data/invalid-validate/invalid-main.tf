terraform {
  required_version = ">= 0.13"
}

resource "null_resource" "example" {
  # Missing required provisioner
  provisioner "local-exec" {
    command = ""
  }
}