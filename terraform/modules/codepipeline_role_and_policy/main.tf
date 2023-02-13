
resource "aws_iam_policy" "AWSCodePipelineServiceRole-policy" {
  name        = var.codepipeline_policy_name
  path        = "/"

  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Sid": "VisualEditor0",
		"Effect": "Allow",
		"Action": [
			"cloudwatch:*",
			"s3:*"
		],
		"Resource": "*"
	}]
}
EOF
}

resource "aws_iam_role" "AWSCodePipelineServiceRole" {
  name = var.codepipeline_policy_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodePipelineServiceRole-policy-attach" {
  role       = "${aws_iam_role.AWSCodePipelineServiceRole.name}"
  policy_arn = "${aws_iam_policy.AWSCodePipelineServiceRole-policy.arn}"
}

output "role_arn" {
  value = aws_iam_role.AWSCodePipelineServiceRole.arn
}