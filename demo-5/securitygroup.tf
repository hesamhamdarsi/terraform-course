data "aws_ip_ranges" "european_ec2" {
  regions  = ["eu-west-1", "eu-central-1"]
  services = ["ec2"]
}

#after creating this rule, you will be able to see a security group called "from_europe" in your AWS security groups with the added rules
resource "aws_security_group" "from_europe" {
  name = "from_europe"

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    #data refer to the data
    #aws_ip_ranges refer to the type of source
    #european_ec2 refer to the name
    #cidr_blocks refer to the attribute
    # 0 , 50 ???
    cidr_blocks = slice(data.aws_ip_ranges.european_ec2.cidr_blocks, 0, 50)
  }
  tags = {
    CreateDate = data.aws_ip_ranges.european_ec2.create_date
    SyncToken  = data.aws_ip_ranges.european_ec2.sync_token
  }
}

