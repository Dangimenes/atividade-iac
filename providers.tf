provider "aws" { 
access_key = "AKIA47E7ZIJ2JYWCY4GY" 
secret_key = "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"
region = "us-east-1" 
}
provider "google" {
  credentials = file("temporal-parser-289000-03c6959cf646.json")

  project = "temporal-parser-289000"
  region  = "us-central1"
  zone    = "us-central1-c"
}


