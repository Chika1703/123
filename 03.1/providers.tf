terraform {
  required_providers {
    twc = {
      source = "tf.timeweb.cloud/timeweb-cloud/timeweb-cloud"
    }
  }
  required_version = "1.11.3"
}

provider "twc" {
  token = var.twc_token
}
