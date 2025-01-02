provider "aws" {
  # password.tf에 저장 : github에는 올라가지 않는 파일
  access_key = var.access_key 
  secret_key = var.secret_key
  region     = var.region
}