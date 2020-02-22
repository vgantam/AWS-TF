# networking main.tf
data "aws_availablity_zones" "available" {
}
resource "aws_vpc" "tf_vpc" {
    cidr_block = "${var.vpc_cid}"
    enable_dns_hostnames = "true"
    enable_dns_support ="true"
    tags{
        name="tf_vpc"
    }
}
resource "aws_internet_gateway" "tf_internet_gateway" {
    vpc_id="${aws_vpc.tf_vpc.id}"
    tags{
        name ="tf_igw"
    }
}
resource "aws_route_table" "tf_public_rt" {
    vpc_id = "${aws_vpc.tf_vpc.vpc_id}"
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.tf_internet_gateway.id}"
    }
    tags{
        Name = "tf_public"
    }
}
resource "aws_default_route_table" "tf_private_rt" {
    default_route_table_id = "${aws_vpc.tf_vpc.default_route_table_id}"
    tags{
        Name = "tf_private"
    }
}
resource "aws_subnet" "tf_public_subnet" {
    count = 2
    vpc_id = "${aws_vpc.tf.id}"
    cidr_block = "${var.public_cidr[count.index]}"
    map_public_ip_on_launch = true
    availability_zone = "${data.aws_availablity_zones.available_names[count.index]}"
    tags {
    name = "tf_public_${count.index + 1}"
    }
}
resource "aws_route_table_association" "tf_public_assoc" {
  count ="${aws_subnet.tf_public_subnet.count}"
  subnet_id = "${aws_subnet.tf_public_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.tf_public_rt.id}"
}
resource "aws_security_group" "tf_public_sg" {
    name = "tf_public_sg"
    description = "used for acces the public instances"
    vpc_id = "${aws_vpc.tf_vpc}"
     
     ingress {
         from_port = 22
         to_port = 22
         protocol = "tcp"
         cidr_blocks = ["${var.accessip}"]
     }
     #http
     ingress {
         from_port = 80
         to_port = 80
         protocol = "tcp"
         cidr_blocks = ["${var.accessip}"]
     }
     egress{
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_block = ["0.0.0.0/0"]
    }
}
