resource "aws_acm_certificate" "portfolio" {
  provider = aws.us_east_1

  domain_name               = "halilfurkandamar.com"
  subject_alternative_names = ["www.halilfurkandamar.com"]
  validation_method         = "DNS"
  key_algorithm             = "RSA_2048"

  options {
    certificate_transparency_logging_preference = "ENABLED"
  }
}
