resource "aws_s3_bucket" "test" {
  bucket = "test-himesh-bucket546"
}
resource "aws_s3_bucket" "test_cicd" {
  bucket = "test-himesh-cicd-pipeline"
}