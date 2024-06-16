resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket-${random_string.suffix.result}"
}

resource "aws_s3_bucket_object" "input" {
  bucket = aws_s3_bucket.example_bucket.bucket
  key    = "input.conf"
  source = "config/input.conf"
}



# Template for Fluent Bit OUTPUT configuration
data "template_file" "fluent_bit_output" {
  template = file("config/output.tpl")

  vars = {
    bucket = "example-bucket-${random_string.suffix.result}"
  }
}

# Upload the generated Fluent Bit configuration to S3
resource "aws_s3_object" "output" {
  bucket = aws_s3_bucket.example_bucket.bucket
  key    = "output.conf"
  content = data.template_file.fluent_bit_output.rendered
}

