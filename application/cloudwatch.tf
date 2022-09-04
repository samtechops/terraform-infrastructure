
resource "aws_cloudwatch_log_group" "go_app" {
    name = "/aws/services/go-app"

    tags = merge(
        {
        Name = "go-app-cloudwatch"
        },
        local.default_tags
    )
}
