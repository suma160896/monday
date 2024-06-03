variable "path_to_linux_key" {
  default     = "/home/ubuntu/environment/secret/mykey.pub"
  description = "Path to the public key to use in Linux VMs provisioning"
  type        = string
}
variable "instance_type" {
  default     = "t2.micro"
  description = "Instance type to use"
  type        = string
}