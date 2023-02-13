module "s3_module" {
  source = "./modules/s3_buckets"
  artifact_bucket_name = var.artifact_bucket_name
  public_bucket_name = var.public_bucket_name
  index_document = var.index_document
}

module "pipeline_policy_role" {
  source = "./modules/codepipeline_role_and_policy"
  codepipeline_policy_name = var.codepipeline_policy_name
  role_name = var.role_name
}

module "pipeline" {
  source = "./modules/codepipeline"
  pipeline_name = var.pipeline_name
  git_repo = var.git_repo
  github_branch = var.github_branch
  github_owner = var.github_owner
  github_token = var.github_token
  role_arn = module.pipeline_policy_role.role_arn
  arti_bucket_name = module.s3_module.arti-bkt
  public_website_bucket_name = module.s3_module.public-bkt
}

output "url" {
  value = join("",["http://",module.s3_module.website-url]) 
}