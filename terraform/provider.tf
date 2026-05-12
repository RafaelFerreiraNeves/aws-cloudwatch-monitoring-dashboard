terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.40.0"
    }
  }

  backend "s3" {
    bucket = "terraformbucketprojetorafaelferreiraneves"
    key    = "env/dev/rafa/terraform.tfstate"
    region = "us-east-1"
  }
}


provider "aws" {
  region = var.aws_region
}