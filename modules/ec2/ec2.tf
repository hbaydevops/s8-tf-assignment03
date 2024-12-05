resource "aws_instance" "ec2" {
  ami           = data.aws_ami.jenkins_master_ami.id 
  instance_type = var.instance_type

  key_name = var.key_name

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  subnet_id = data.aws_subnet.subnet_01.id

  root_block_device {
    volume_size = var.root_volume     # Size in GB
    volume_type = "gp3"   # Set volume type to gp3
  }

  # Merge base_tags with custom_tags to form the final tag set
  tags = merge(
    var.tags,
    { Name = format("%s-%s-${var.instance_name}", var.tags["environment"], var.tags["project"]) }  # Default Name tag
  )

}

