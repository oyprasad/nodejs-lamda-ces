data "aws_iam_policy_document" "assume_role1" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "lambda-demo-1"
  assume_role_policy = data.aws_iam_policy_document.assume_role1.json
}


resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  #filename      = "lambda_function_payload.zip"
  s3_bucket =  "test-node-js-bucket-ces"
  s3_key = "codebuild-for-lambda-main.zip"
  function_name = "lambda-demo"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"

  #source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs16.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}
resource "aws_iam_role_policy_attachment" "cloudwatch_role_policy_attachment_lambda" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.iam_for_lambda.name
}
