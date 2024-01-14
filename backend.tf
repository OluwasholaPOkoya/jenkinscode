terraform {
  backend "s3" {
    bucket = "sholaterrabucket"
    key    = "jenkins/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    dynamodb_table = "Terraformlock"
  }
}