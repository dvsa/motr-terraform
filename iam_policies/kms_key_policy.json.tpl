{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable Lambda permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${MotrWebAppLambda_role_arn}",
          "${MotrSubscriptionLoaderLambda_role_arn}",
          "${MotrNotifierLambda_role_arn}"
        ]
      },
      "Action": [ 
        "kms:Decrypt"
      ],
      "Resource": "arn:aws:kms:${aws_region}:${account_id}:key/*"
    },
    {
      "Sid": "Enable key management Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "arn:aws:kms:${aws_region}:${account_id}:key/*"
    }
  ]
}
