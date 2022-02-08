resource "aws_elb" "my-elb" {
  name               = "My-ELB"
  subnets = [ aws_subnet.pubsub-1.id ]
  security_groups = [ aws_security_group.sg-elb.id]
  

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 3
    timeout             = 5
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = [aws_instance.web_instance.id,aws_instance.web_instance2.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "My-ELB"
  }
}