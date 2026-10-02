resource "aws_cloudfront_function" "www_to_apex" {
  name    = "portfolio-www-to-apex-redirect"
  runtime = "cloudfront-js-2.0"
  comment = "Redirect www hostname to canonical apex"
  publish = false
  code    = file("${path.module}/../cloudfront/functions/www-to-apex.js")
}
