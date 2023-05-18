resource "aws_api_gateway_rest_api" "example_api" {
  name = var.Rest-API
  description = "An example REST API Gateway"
}

# REST API Gateway resource
resource "aws_api_gateway_resource" "example_resource" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  parent_id   = aws_api_gateway_rest_api.example_api.root_resource_id
  path_part   = "name"
  
}

# REST API Gateway method
resource "aws_api_gateway_method" "example_method" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  resource_id = aws_api_gateway_resource.example_resource.id
  http_method = "GET"
  authorization = "NONE"
  
}




# Lambda integration
resource "aws_api_gateway_integration" "example_integration" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  resource_id = aws_api_gateway_resource.example_resource.id
  http_method = aws_api_gateway_method.example_method.http_method
  #http_method = "GET"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  #integration_http_method = "GET"
  #Lambda Proxy integration  =  false
  #proxy = false
  uri = aws_lambda_function.test_lambda.invoke_arn
  #is_proxy_integration = false
  #lambda_proxy = false
}
/*
resource "aws_api_gateway_method_response" "my_method_response" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  resource_id = aws_api_gateway_resource.example_resource.id
  #http_method = aws_api_gateway_method.example_method.http_method
  http_method = "GET"
  status_code = "200"

  #response_parameters = {
  #  "method.response.header.Access-Control-Allow-Origin" = true 
 # }
  response_models = {
   "application/json" = "Empty"  
  }
}


resource "aws_api_gateway_model" "my_empty_model" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  name        = "EmptyModel"
  content_type = "application/json"
  schema      = jsonencode({})

  
}


resource "aws_api_gateway_method_response" "test" {
    rest_api_id = aws_api_gateway_rest_api.example_api.id
    resource_id = aws_api_gateway_resource.example_resource.id
    http_method = aws_api_gateway_method.example_method.http_method
    status_code = "200"

    response_models = {
         "application/json" = "Empty"
    }
}

resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
   rest_api_id = aws_api_gateway_rest_api.example_api.id
   resource_id = aws_api_gateway_resource.example_resource.id
   http_method = aws_api_gateway_method.example_method.http_method
   status_code = "${aws_api_gateway_method_response.test.status_code}"

   response_templates = {
       "application/json" = ""
   }
}

*/
resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.test_lambda.arn}"
  #function_name = "lambda-demo"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.example_api.execution_arn}/*/*"
}


resource "aws_api_gateway_deployment" "my_deployment" {
   depends_on = [ 
           aws_api_gateway_method.example_method,
           aws_api_gateway_integration.example_integration,
   ] 
   rest_api_id = aws_api_gateway_rest_api.example_api.id
   stage_name  = "prod1"
}
output "example_invoke_url" {
  value = "${aws_api_gateway_deployment.my_deployment.invoke_url}/name"
}
# output "lambda_arncheck" {
#  value = "${aws_lambda_permission.api_gateway_invoke.function_name}"
#} 


resource "aws_iam_policy" "rest_api_cloudwatch_policy" {
  name        = "rest-api-cloudwatch-policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CloudWatchLogs",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream"
            ],
            "Resource": "*"
        },
        {
            "Sid": "CloudWatchMetrics",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "rest_api_cloudwatch_role" {
  name = "rest-api-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rest_api_cloudwatch_attachment" {
  policy_arn = aws_iam_policy.rest_api_cloudwatch_policy.arn
  role       = aws_iam_role.rest_api_cloudwatch_role.name
}

