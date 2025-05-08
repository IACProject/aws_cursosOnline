resource "aws_sfn_state_machine" "course_approval_flow" {
  name     = "OnlineReady-CourseApproval-${var.environment}"
  role_arn = aws_iam_role.step_functions_role.arn

  definition = <<EOF
{
  "Comment": "Flujo de aprobación de cursos",
  "StartAt": "ValidateCourse",
  "States": {
    "ValidateCourse": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.course_validator.arn}",
      "Next": "NotifyApproval"
    },
    "NotifyApproval": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.notifier.arn}",
      "Parameters": {
        "action": "approval-notification",
        "course_id.$": "$.course_id"
      },
      "End": true
    }
  }
}
EOF
}

resource "aws_iam_role" "step_functions_role" {
  name = "OnlineReady-StepFunctions-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "states.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "step_functions_policy" {
  name = "OnlineReady-StepFunctions-Policy"
  role = aws_iam_role.step_functions_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction"
        ],
        Resource = [
          aws_lambda_function.course_validator.arn,
          aws_lambda_function.notifier.arn
        ]
      }
    ]
  })
}