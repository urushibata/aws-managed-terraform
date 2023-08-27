resource "aws_organizations_policy" "region_restriction_policy" {
  name        = "regionRestrictionPolicy-${var.environment}"
  description = "Tokyo(ap-northeast-1), North Virginia(us-east-1) region"
  content     = data.aws_iam_policy_document.region_restriction.json
}
