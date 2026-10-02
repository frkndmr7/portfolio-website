resource "aws_lambda_permission" "api_gateway_get_legacy" {
  statement_id  = "a852944f-ef20-57e4-b5c8-47d6ba1a5b5b"
  action        = "lambda:InvokeFunction"
  function_name = "VisitorCounterFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:eu-west-1:442042531579:ts8ov8jvde/*/GET/counter"
}

resource "aws_lambda_permission" "api_gateway_get" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "VisitorCounterFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:eu-west-1:442042531579:ts8ov8jvde/*/GET/counter"
}

resource "aws_lambda_permission" "api_gateway_options" {
  statement_id  = "AllowAPIGatewayOptionsInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "VisitorCounterFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:eu-west-1:442042531579:ts8ov8jvde/*/OPTIONS/counter"
}
