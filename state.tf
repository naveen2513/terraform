terraform {
  backend "s3" {
    bucket = "terraform-0407"
    key    = "roboshop/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
