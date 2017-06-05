variable "aws_profile" {}
variable "aws_region" {}
variable "subdomain" {}

provider "aws" {
  profile = "${var.aws_profile}"
  region = "${var.aws_region}"
}

data "aws_availability_zones" "available" {}

data "aws_route53_zone" "domain" {
  # get the domain from the subdomain
  name = "${join(".",slice(split(".",var.subdomain), 1, length(split(".",var.subdomain))))}"
}

resource "aws_route53_zone" "subdomain" {
  name = "${var.subdomain}"
}

resource "aws_s3_bucket" "state" {
  bucket = "${var.subdomain}"
  acl    = "private"
  tags {
    Name = "${var.subdomain}"
  }
}

resource "aws_route53_record" "subdomain" {
  zone_id = "${data.aws_route53_zone.domain.zone_id}"
  name    = "${var.subdomain}"
  type    = "NS"
  ttl     = "30"
  records = [
    "${aws_route53_zone.subdomain.name_servers.0}",
    "${aws_route53_zone.subdomain.name_servers.1}",
    "${aws_route53_zone.subdomain.name_servers.2}",
    "${aws_route53_zone.subdomain.name_servers.3}",
  ]
  provisioner "local-exec" {
    # kops generates terraform files in /out
    command = "kops create cluster --name=${var.subdomain} --state=s3://${var.subdomain} --zones=${data.aws_availability_zones.available.names[0]},${data.aws_availability_zones.available.names[1]} --target=terraform"
  }
}