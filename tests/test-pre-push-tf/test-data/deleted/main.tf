# Deleted invalid tf file, should be ignored
terraform{
required_version= ">= 0.13"
}

resource "null_resource" "example"{
provisioner "local-exec"{
command="echo Hello World"
}
}