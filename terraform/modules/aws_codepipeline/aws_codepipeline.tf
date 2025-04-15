resource "aws_codestarconnections_connection" "github" {
  name          = var.codestar_connection_name
  provider_type = "GitHub"

  tags = {
    Environment = var.environment
    Team        = var.team_name
    Description = var.description
    Creator     = var.creator
  }
}

resource "aws_s3_bucket" "default_bucket" {
  bucket = "${var.name}-codepipeline-${var.account_id}-s3"

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
      "Effect" : "Allow",
      "Action" : [
        "codedeploy:*"
      ],
      "Resource" : "*"
    },
    {
      "Effect" : "Allow",
      "Action" : [
        "ecs:*"
      ],
      "Resource" : "*"
    },
    {
      "Effect" : "Allow",
      "Action" : [
        "iam:PassRole"
      ],
      "Resource" : "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codestar-connections:UseConnection"
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
  pipeline_type = "V2"

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
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = "${var.github_owner}/${var.github_repo}"
        BranchName       = var.github_branch
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






