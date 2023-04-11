terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.7.0"
    }
  }

  required_version = ">= 1.3.4"


  backend "remote" {
    organization = "jcetina"

    workspaces {
      name = "gh_jcetina_baklava"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  use_oidc = true
  features {
  }
}

provider "azurerm" {
  alias    = "vault"
  use_oidc = true
  features {
    key_vault {
      purge_soft_deleted_keys_on_destroy = false
      recover_soft_deleted_keys          = true
    }
  }
}