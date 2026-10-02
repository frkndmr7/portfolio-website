resource "aws_iam_role" "visitor_counter" {
  name                 = "VisitorCounterFunction-role-uw6ylj8p"
  path                 = "/service-role/"
  max_session_duration = 3600

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.visitor_counter.name
  policy_arn = "arn:aws:iam::442042531579:policy/service-role/AWSLambdaBasicExecutionRole-4aa3a330-7220-49cf-9d87-5706eb246249"
}

resource "aws_iam_role_policy_attachment" "dynamodb_full_access" {
  role       = aws_iam_role.visitor_counter.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}
