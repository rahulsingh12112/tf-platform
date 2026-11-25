terraform {
  backend "s3" {
    bucket       = "tfstate-208707054038-us-east-1"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}