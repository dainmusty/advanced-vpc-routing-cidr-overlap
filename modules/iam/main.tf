# --- Admin Role ---
# Admin Policy
data "aws_iam_policy_document" "admin_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = var.admin_role_principals
    }
    actions = ["sts:AssumeRole"]
  }
}

# Admin Role
resource "aws_iam_role" "admin_role" {
  name                 = "admin-role"
  assume_role_policy   = data.aws_iam_policy_document.admin_assume.json
  
}

# Admin Policy
resource "aws_iam_policy" "admin_policy" {
  name        = "admin-full-access"
  description = "Full admin access for admin role"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "*",
        Resource = "*"
      }
    ]
  })
}

# Admin Role Policy Attachment
resource "aws_iam_role_policy_attachment" "attach_admin_policy" {
  role       = aws_iam_role.admin_role.name
  policy_arn = aws_iam_policy.admin_policy.arn
}


# RBAC Instance Profile
resource "aws_iam_instance_profile" "rbac_instance_profile" {
  name = "dev-rbac-instance-profile"
  role = aws_iam_role.admin_role.name
}



