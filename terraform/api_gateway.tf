locals {
  visitor_counter_lambda_arn = "arn:aws:lambda:eu-west-1:442042531579:function:VisitorCounterFunction"
}

resource "aws_api_gateway_rest_api" "visitor_counter" {
  name = "VisitorCounterAPI"

  api_key_source               = "HEADER"
  disable_execute_api_endpoint = false

  endpoint_configuration {
    types           = ["REGIONAL"]
    ip_address_type = "ipv4"
  }
}

resource "aws_api_gateway_resource" "counter" {
  rest_api_id = aws_api_gateway_rest_api.visitor_counter.id
  parent_id   = aws_api_gateway_rest_api.visitor_counter.root_resource_id
  path_part   = "counter"
}

resource "aws_api_gateway_method" "counter_get" {
  rest_api_id   = aws_api_gateway_rest_api.visitor_counter.id
  resource_id   = aws_api_gateway_resource.counter.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "counter_options" {
  rest_api_id   = aws_api_gateway_rest_api.visitor_counter.id
  resource_id   = aws_api_gateway_resource.counter.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "counter_get" {
  rest_api_id             = aws_api_gateway_rest_api.visitor_counter.id
  resource_id             = aws_api_gateway_resource.counter.id
  http_method             = aws_api_gateway_method.counter_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/${local.visitor_counter_lambda_arn}/invocations"
  passthrough_behavior    = "WHEN_NO_MATCH"
  content_handling        = "CONVERT_TO_TEXT"
  timeout_milliseconds    = 29000
  cache_namespace         = "21lq0d"
}

resource "aws_api_gateway_integration" "counter_options" {
  rest_api_id             = aws_api_gateway_rest_api.visitor_counter.id
  resource_id             = aws_api_gateway_resource.counter.id
  http_method             = aws_api_gateway_method.counter_options.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/${local.visitor_counter_lambda_arn}/invocations"
  passthrough_behavior    = "WHEN_NO_MATCH"
  content_handling        = "CONVERT_TO_TEXT"
  timeout_milliseconds    = 29000
  cache_namespace         = "21lq0d"
}

resource "aws_api_gateway_method_response" "counter_get_200" {
  rest_api_id = aws_api_gateway_rest_api.visitor_counter.id
  resource_id = aws_api_gateway_resource.counter.id
  http_method = aws_api_gateway_method.counter_get.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "counter_options_200" {
  rest_api_id = aws_api_gateway_rest_api.visitor_counter.id
  resource_id = aws_api_gateway_resource.counter.id
  http_method = aws_api_gateway_method.counter_options.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = false
    "method.response.header.Access-Control-Allow-Methods" = false
    "method.response.header.Access-Control-Allow-Origin"  = false
  }

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "counter_get_200" {
  rest_api_id = aws_api_gateway_rest_api.visitor_counter.id
  resource_id = aws_api_gateway_resource.counter.id
  http_method = aws_api_gateway_method.counter_get.http_method
  status_code = aws_api_gateway_method_response.counter_get_200.status_code

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_deployment" "visitor_counter" {
  rest_api_id = aws_api_gateway_rest_api.visitor_counter.id
  description = "Enable dynamic CORS for portfolio visitor counter"
}

resource "aws_api_gateway_stage" "prod" {
  rest_api_id   = aws_api_gateway_rest_api.visitor_counter.id
  deployment_id = aws_api_gateway_deployment.visitor_counter.id
  stage_name    = "prod"
}
