resource "aws_s3_bucket" "manual-bucket1234" {
  bucket = "manual-bucket123412"

  tags = {
    Name        = "My bucket"
    Created-by = "shivangi"
  }
}
