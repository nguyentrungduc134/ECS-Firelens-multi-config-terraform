# ECS-Firelens-multi-config-terraform     
<!-- x-release-please-start-version -->
  ```
    Version : '8.0.0'

  ```
<!-- x-release-please-end -->
## Introduction

This document provides a comprehensive guide on setting up your ECS Task role to enable log creation and downloading configuration files from an S3 bucket. Additionally, it includes details about using bind mounts in Amazon ECS and a specific Terraform resource configuration to upload a Fluent Bit configuration file to an S3 bucket.

## Enabling Log Creation (`logs:CreateLogGroup`)

To enable log creation, ensure that your ECS Task role includes the necessary permissions. The following policy grants the required permissions for creating log groups in Amazon CloudWatch.

### Policy to Enable Log Creation

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup"
            ],
            "Resource": "*"
        }
    ]
}
```

## Setting Up Your ECS Task Role

When specifying the configuration file from your S3 bucket, the init process will download it from your bucket. Ensure that your ECS Task role has the following permissions to access the S3 bucket:

### S3 Bucket Permissions for ECS Task Role

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetBucketLocation"
            ],
            "Resource": "*"
        }
    ]
}
```

## Purpose of Using Bind Mounts in Amazon ECS

Bind mounts are used in Amazon ECS to allow containers to access files on the host instance. This is particularly useful for sharing data between the host and the containers.


## Terraform Configuration for Fluent Bit Configuration File

The following Terraform resource configuration is used to upload a Fluent Bit configuration file to an S3 bucket.

### Terraform Resource Configuration

```hcl
[root@ip-172-31-27-174 ECS-Firelens-multi-config-terraform]# cat config.tf
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

```

In the `config/output.tpl` file, you can use the following template:

```txt
[OUTPUT]
    Name                         s3
    Match                        app
    bucket                       ${bucket_name}
    region                       us-east-1
    total_file_size              1M
    upload_timeout               1m
    use_put_object               On
```

## Conclusion

This guide provides essential information on configuring ECS Task roles for log creation, setting up S3 bucket permissions, using bind mounts in ECS, and uploading Fluent Bit configuration files using Terraform. Follow the examples and best practices outlined here to ensure a smooth setup and operation of your ECS tasks.
