#This is where the image created from the application's source code will be stored and will be 
#later be consumed by ECS 
resource "aws_ecr_repository" "nestjs_image_repository" {
  name                 = "${local.name_prefix}-image-repository"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}