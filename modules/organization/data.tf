# リージョン制限
data "aws_iam_policy_document" "region_restriction" {
  statement {
    sid    = "regionRestriction"
    effect = "Deny"
    actions = [
      "*"
    ]
    resources = [
      "*"
    ]
    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "aws:RequestedRegion"
      values = [
        "ap-northeast-1",
        "us-east-1"
      ]
    }
  }
}
