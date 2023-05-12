resource "aws_codebuild_project" "example" {
  name              = "example-project-demo"
  description       = "An example CodeBuild project"
  service_role      = aws_iam_role.codebuild_s3_role.arn
  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
  }
  source {
    type            = "S3"
    location        = "arn:aws:s3:::test-node-js-bucket-ces/codebuild-for-lambda-main.zip"
    buildspec       = "arn:aws:s3:::test-node-js-bucket-ces/buildspec.yml"
  }
  
  artifacts {
    type            = "S3"
    location        = "arn:aws:s3:::test-node-js-bucket-ces"
    name            = "example-project-demo"
  }
  
 
  build_timeout     = 60
  tags              = {
    Terraform       = "true"
  }
 
}


resource "aws_iam_role" "codebuild_s3_role" {
  name = "codebuild_s3_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "cloudwatch_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
  role       = aws_iam_role.codebuild_s3_role.name
}
resource "aws_iam_role_policy_attachment" "lambda_execution_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
  role       = aws_iam_role.codebuild_s3_role.name
}
resource "aws_iam_role_policy_attachment" "codebuild_s3_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.codebuild_s3_role.name
}


