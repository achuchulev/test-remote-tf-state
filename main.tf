# Use random_pet to generate a random name  
resource "random_pet" "someword" {
  length    = var.words
  separator = "-"
}

variable "words" {
  default = 4
}

data "terraform_remote_state" "test" {
  backend = "remote"

  config = {
    organization = "atanas"
    workspaces = {
      name = "tf-random_pet"
    }
  }
}

data "tfe_workspace" "my-ws" {
  name         = "test-remote-tf-state"
  organization = "atanas"
}

resource "tfe_variable" "test" {
  key          = "my_key_name"
  value        = data.terraform_remote_state.test.outputs.ext-id
  category     = "terraform"
  workspace_id = data.tfe_workspace.my-ws.id
  description  = "test variable"
}
