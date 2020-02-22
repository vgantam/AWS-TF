# Storage main.tf
resource "random_id" "tf_bucket_id" {
  byte_length = 2
}
#create a bucket
resource "aws_s3_bucket" "tf_code" {
    bucket = "${var.project_name}-${random_id.tf_bucket_id.dec}"
    acl = "private"
    force_destroy = "true"
 
}
