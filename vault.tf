resource "aws_instance" "vault_dev" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instances.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  key_name               = aws_key_pair.generated_key.key_name
  root_block_device {
    volume_size = 100
    volume_type = "io1"
    iops        = 1000
  }
  user_data = templatefile("cloudinit_vault_dev.yaml", {
    consul_retry_join = "provider=aws tag_key=Name tag_value=consul_server_${random_pet.pet.id}"
  })
  tags = {
    Name = "vault_dev_${random_pet.pet.id}"
  }
}
