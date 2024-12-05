output "vpc_id" {
  value = data.aws_vpc.vpc.id
}

output "subnet_01" {
  value = data.aws_subnet.subnet_01.id
}

output "jenkins_master_ami" {
  value = data.aws_ami.jenkins_master_ami.id
}

output "Jenkins-master-eip" {
  value = aws_eip.jenkins_eip.id
}

output "key_pair_data" {
  value = var.key_name
}
