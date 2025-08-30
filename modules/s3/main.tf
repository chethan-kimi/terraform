resource "aws_s3_bucket" "bucket" {
  bucket = "${var.env}-state-bucket-${random_id.bucket_id.hex}"
  acl    = "private"

  tags = {
    Environment = var.env
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}
