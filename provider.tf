terraform {
  backend "s3" {
    bucket                  = "consultfstate"
    region                  = "eu-central-1"
    key                     = "terraform.tfstate"
    shared_credentials_file = "~/.aws/credentials"
  }
}

provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "~/.aws/credentials"
}
