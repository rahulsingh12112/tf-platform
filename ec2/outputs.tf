output "instance_id" {
  value = aws_instance.lab.id
}

output "private_ip" {
  value = aws_instance.lab.private_ip
}

output "ssm_connect" {
  value = "aws ssm start-session --target ${aws_instance.lab.id} --region ${var.region}"
}
