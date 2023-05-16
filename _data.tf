# Get AZ's for the region automatically
data "aws_availability_zones" "available" {
  state = "available"
}
