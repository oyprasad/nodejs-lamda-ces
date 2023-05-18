variable "region" {
  type = string
  default = "us-east-1"
}


variable "s3_bucket" {
  type = string
  default = "test-node-js-bucket-ces"
}

variable "s3_key" {
  type = string
  default = "codebuild-for-lambda-main.zip"
}

variable "handler" {
  type = string
  default = "index.handler"
}
variable "runtime" {
  type = string
  default = "nodejs16.x"
}
variable "codebuild_project" {
  type = string
  default = "example-project-demo"
}

variable "buildbuild_project_enviornment_compute_type" {
   type = string
   default = "BUILD_GENERAL1_SMALL"
}
variable "buildbuild_project_enviornment_image" {
   type = string
   default = "aws/codebuild/standard:5.0"
}

variable "buildbuild_project_enviornment_type" {
   type = string
   default = "LINUX_CONTAINER"

}

/*
variable "buildbuild_project_enviornment_variables" {
  type = map(string)
  default = {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:5.0"
    type1 = "LINUX_CONTAINER"
  }
}

*/

variable "Rest-API" {
  type = string
  default = "example_api"
}

variable "pipeline" {
  type = string
  default = "tf-nodejs-pipeline-test-demo"
}
