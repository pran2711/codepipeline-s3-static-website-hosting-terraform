resource "aws_codepipeline" "github" {
  name     = var.pipeline_name
  role_arn = var.role_arn

  artifact_store {
    location = var.arti_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        Owner  = var.github_owner
        Repo   = var.git_repo
        Branch = var.github_branch
       OAuthToken = var.github_token
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["SourceArtifact"]
      version         = "1"

      configuration = {
        BucketName = var.public_website_bucket_name
        Extract = "true"
      }
    }
  }
}