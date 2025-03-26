resource "aws_s3_bucket" "default_bucket" {
  bucket = "${var.name}-codepipeline-bucket"

  tags = {
    Environment = var.environment
    Team        = var.team_name
    Description = var.description
    Creator     = var.creator
  }
}

resource "aws_iam_role" "default_role" {
  name = "${var.name}-codepipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.default_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.default_bucket.arn}",
        "${aws_s3_bucket.default_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codecommit:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_AdministratorAccessPolicy" {
  role       = aws_iam_role.default_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_codepipeline" "dafault_codepipeline" {
  name     = "${var.name}-pipeline"
  role_arn = aws_iam_role.default_role.arn

  artifact_store {
    location = aws_s3_bucket.default_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source-${var.name}-stage"

    action {
      name             = "Source-${var.name}-action"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName       = var.name
        BranchName           = "main"
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build-${var.name}-stage"

    action {
      name             = "Build-${var.name}-action"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "${var.name}-project"
      }
    }
  }

  stage {
    name = "Deploy-${var.name}-stage"

    action {
      name            = "Deploy-${var.name}-action"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ApplicationName                = var.cd_app_name
        DeploymentGroupName            = var.cd_d_grp_name
        AppSpecTemplatePath            = "appspec.yaml"
        AppSpecTemplateArtifact        = "build_output"
        Image1ArtifactName             = "build_output"
        TaskDefinitionTemplateArtifact = "build_output"
        TaskDefinitionTemplatePath     = "taskdef.json"
        Image1ContainerName            = "IMAGE1_NAME"
      }
    }
  }

  tags = {
    Environment = var.environment
    Team        = var.team_name
    Description = var.description
    Creator     = var.creator
  }
}


resource "aws_iam_role" "event_role" {
  name = "${var.name}-codepipeline-rule-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_event_rule_policy" {
  name = "${var.name}-codepipeline_policy"
  role = aws_iam_role.event_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "codepipeline:StartPipelineExecution"
        ],
        "Resource" : [
          aws_codepipeline.dafault_codepipeline.arn
        ]
      }
    ]
  })

}

resource "aws_cloudwatch_event_rule" "default_event_rule" {
  name        = "codepipeline-${var.name}-event-rule"
  description = "Amazon CloudWatch Events rule to automatically start your pipeline when a change occurs in the AWS CodeCommit source repository and branch."

  event_pattern = jsonencode({
    "source" : ["aws.codecommit"],
    "detail-type" : ["CodeCommit Repository State Change"],
    "resources" : [var.code_repo_arn],
    "detail" : {
      "event" : ["referenceCreated", "referenceUpdated"],
      "referenceType" : ["branch"],
      "referenceName" : ["main"]
    }
  })
}

resource "aws_cloudwatch_event_target" "pipeline" {
  rule      = aws_cloudwatch_event_rule.default_event_rule.name
  target_id = "${var.name}-taget"
  arn       = aws_codepipeline.dafault_codepipeline.arn
  role_arn  = aws_iam_role.event_role.arn
}
