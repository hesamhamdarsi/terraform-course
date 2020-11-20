#as this module is external, we need to first download it from the source using "source"
# as we want to insert and run the scripts through this module, we can use our pub/private key for that
module "consul" {
  source   = "github.com/wardviaene/terraform-consul-module.git?ref=terraform-0.12"
  #as we uploaded the public key in AWS, here we say use the same private key in AWS
  key_name = aws_key_pair.mykey.key_name
  # but as we don't upload the private key, we need to add our private key path in the file
  key_path = var.PATH_TO_PRIVATE_KEY
  region   = var.AWS_REGION
  vpc_id   = aws_default_vpc.default.id
  subnets = {
    "0" = aws_default_subnet.default_az1.id
    "1" = aws_default_subnet.default_az2.id
    "2" = aws_default_subnet.default_az3.id
  }
}

output "consul-output" {
  value = module.consul.server_address
}

