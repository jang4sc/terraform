output "instance_public_dns" {
  value = aws_instance.bsc-instance.public_dns
}

output "instance_public_ip" {
  value = "ssh -i ~/.ssh/bsckey ubuntu@${aws_instance.bsc-instance.public_ip}"
}