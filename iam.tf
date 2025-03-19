resource "aws_iam_role" "tf_codepipeline_role" {
  name = "tf_codepipeline_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "tf_cicd_policy" {
  statement {
    sid = ""
    actions = ["codestar-connections:UseConnection"]
    effect = "Allow"
    resources = ["*"]
  }
  statement {
    sid = ""
    actions = ["s3:*","cloudwatch:*","codebuild:*"]
    effect = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "tf_cicd_policy" {
  name        = "tf_cicd_policy"
  path = "/"
  description = "Policy for CICD"
  policy      = data.aws_iam_policy_document.tf_cicd_policy.json  
}

resource "aws_iam_role_policy_attachment" "tf_cicd_policy_attachment" {
  policy_arn = aws_iam_policy.tf_cicd_policy.arn
  role       = aws_iam_role.tf_codepipeline_role.id
}

resource "aws_iam_role" "tf-codebuild-role" {
  name = "tf-codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

data "aws_iam_policy_document" "tf-cicd-build-policies" {
    statement{
        sid = ""
        actions = ["logs:*", "s3:*", "codebuild:*", "secretsmanager:*","iam:*"]
        resources = ["*"]
        effect = "Allow"
    }
}

resource "aws_iam_policy" "tf-cicd-build-policy" {
    name = "tf-cicd-build-policy"
    path = "/"
    description = "Codebuild policy"
    policy = data.aws_iam_policy_document.tf-cicd-build-policies.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-codebuild-attachment1" {
    policy_arn  = aws_iam_policy.tf-cicd-build-policy.arn
    role        = aws_iam_role.tf-codebuild-role.id
}

resource "aws_iam_role_policy_attachment" "tf-cicd-codebuild-attachment2" {
    policy_arn  = "arn:aws:iam::aws:policy/PowerUserAccess"
    role        = aws_iam_role.tf-codebuild-role.id
}