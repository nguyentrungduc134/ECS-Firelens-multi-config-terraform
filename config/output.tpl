[OUTPUT]
    Name                         s3
    Match                        host
    bucket                       ${bucket}
    region                       us-east-1
    total_file_size              1M
    upload_timeout               1m
    use_put_object               On
[OUTPUT]
    Name                         s3
    Match                        container
    bucket                       ${bucket}
    region                       us-east-1
    total_file_size              1M
    upload_timeout               1m
    use_put_object               On

