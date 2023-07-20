resource "aws_network_interface" "bastion" {
  subnet_id   = data.terraform_remote_state.network.outputs.public_subnets.0

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = var.instance_type

  network_interface {
    network_interface_id = aws_network_interface.bastion.id
    device_index         = 0
  }

  iam_instance_profile = aws_iam_instance_profile.test_profile.name_prefix
  tags = { 
    Name = "Bastion-Mihai"
  }

}