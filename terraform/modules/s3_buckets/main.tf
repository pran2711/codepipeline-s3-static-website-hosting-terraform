resource "aws_s3_bucket" "website-artifacts" {  
  bucket_prefix = var.artifact_bucket_name  
  acl    = "private"   
}

resource "aws_s3_bucket" "production_website" {  
  bucket_prefix = var.public_bucket_name  
  acl    = "public-read"   

  website {    
    index_document = var.index_document    
  }
}

resource "aws_s3_bucket_policy" "production_website" {  
  bucket = aws_s3_bucket.production_website.id   
policy = <<POLICY
{    
    "Version": "2012-10-17",    
    "Statement": [        
      {            
          "Sid": "PublicReadGetObject",            
          "Effect": "Allow",            
          "Principal": "*",            
          "Action": [                
             "s3:GetObject"            
          ],            
          "Resource": [
             "arn:aws:s3:::${aws_s3_bucket.production_website.id}/*"            
          ]        
      }    
    ]
}
POLICY
}

output "arti-bkt" {
  value = aws_s3_bucket.website-artifacts.bucket
}

output "public-bkt" {
  value = aws_s3_bucket.production_website.bucket
}

output "website-url" {
  value = aws_s3_bucket.production_website.website_endpoint
}