resource "aws_instance" "monitoring_instance" {

  ami = "ami-0c02fb55956c7d316"

  instance_type = "t2.micro"

  subnet_id = aws_subnet.public_subnet.id
  
  key_name = "my-key"

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = file("../app/user-data.sh")

  tags = {
    Name = "observability-ec2"
  }
}