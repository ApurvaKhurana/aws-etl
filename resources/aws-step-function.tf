resource "aws_sfn_state_machine" "this" {

  name       = var.state_machine_name
  role_arn   = aws_iam_role.this[0].arn
  definition = data.template_file.my_asl

  type = "STANDARD"
}

#asl definition
data "template_file" "my_asl" {
  template = file("./scripts/my_state_machine")

  vars {
    src_s3_bucket  = var.src_s3_bucket
    src_s3_path    = var.src_s3_path
    dest_s3_bucket = var.dest_s3_bucket
    dest_s3_path   = var.dest_s3_path
    dd_table_name  = var.dd_table_name
    key1           = var.key1
    value1         = var.value1
  }
}

# IAM Role
resource "aws_iam_role" "this" {
  name        = local.role_name
  description = var.role_description
  tags        = merge(var.tags, var.role_tags)
}
