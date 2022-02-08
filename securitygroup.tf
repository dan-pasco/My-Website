
variable "ingressvar" {

  type = list(number)
  default = [ 80,443,22 ]
  
}

variable "egressvar" {

  type = list(number)
  default = [ 80,443,22 ]
  
}



resource "aws_security_group" "sg-elb" {

  name = "SG for ELB"
  vpc_id = aws_vpc.custom_vpc.id

  dynamic "ingress"{
    iterator = port
    for_each = var.ingressvar
    content{
      from_port = port.value
      to_port = port.value
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }

  dynamic "egress"{
    iterator = port
    for_each = var.egressvar
    content{
      from_port = port.value
      to_port = port.value
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }
  
  tags = {

    Name = "SG for ELB"

  }
}

resource "aws_security_group" "instance-security" {
  name        = "allow_tls"
  description = "Allow TLS inbound 80 and 22"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description      = "Allow HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [ aws_security_group.sg-elb.id ]
  }

  

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}