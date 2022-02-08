
resource "aws_instance" "web_instance" {
    #My website AMI
  ami           = "ami-0ae77e53d9de53d0e"
  instance_type = "t2.micro"
  # OUTPUT OF SG NAME USED
  security_groups = [aws_security_group.instance-security.id]
  subnet_id = aws_subnet.pubsub-1.id
  key_name =  "EC2website"
  
  
  
  tags = {
    Name = "Web Server"
}
}

