#--- Storage outputs.tf
output "bucketname" {
  value = "${module.storage.bucketname}"
}