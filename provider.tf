terraform {
  backend "s3" {
    bucket                  = "consultfstate"
    region                  = "${var.region}"
    key                     = "terraform.tfstate"
    shared_credentials_file = "~/.aws/credentials"
  }
}

provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "~/.aws/credentials"
}
