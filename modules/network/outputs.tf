output "vpc_id"    { value = aws_vpc.this.id }
output "public_ip" { value = aws_eip.this.public_ip }