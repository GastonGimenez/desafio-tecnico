provider "aws" {
  
  region = var.region_principal
  
  default_tags {
    tags = local.tags
  }

}

provider "aws" {
  
  region = var.region_destination

  alias = "replication"
  
  default_tags {
    tags = local.tags
  }

}

