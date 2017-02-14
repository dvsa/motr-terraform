{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable Lambda permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${kms_role_arn}"
      },
      "Action": [ 
        "kms:Enable*",
        "kms:Get*",
        "kms:Describe*",
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Enable key management Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${account_id}:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}