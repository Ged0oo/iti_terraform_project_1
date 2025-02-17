terraform {
	backend "s3" {
		bucket         = "lab-bucket-229229229"
		key            = "terraform.tfstate"
		region         = "us-east-1"
		dynamodb_table = "testing-table"
	}
}
