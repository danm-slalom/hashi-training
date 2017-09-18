#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-1d4e7a66
#
# Your subnet ID is:
#
#     subnet-27f55043
#
# Your security group ID is:
#
#     sg-e72efe94
#
# Your Identity is:
#
#     terraform-hedgehog
#

terraform {
  backend "atlas" {
    name    = "dmazur_slalom/terraform_state"
    address = "https://atlas.hashicorp.com"
  }
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

resource "aws_instance" "web" {
  count                  = "${var.num_webs}"
  ami                    = "ami-1d4e7a66"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-27f55043"
  vpc_security_group_ids = ["sg-e72efe94"]

  tags {
    "Identity"      = "terraform-hedgehog"
    "Locale"        = "Austin"
    "InstanceIndex" = "web ${count.index + 1} of ${var.num_webs}"
  }
}

module "say-it-loud" {
  source  = "example-module"
  command = "toilet -w 120 HashiConf2017"
}

output "web_public_ip" {
  value = "${aws_instance.web.*.public_ip}"
}

output "web_public_dns" {
  value = "${aws_instance.web.*.public_dns}"
}
